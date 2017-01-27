<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:import url="../header.jsp"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/schema-table.css" type="text/css">

<div class="ebi-content">
    <div class="grid_24">

        <div style="height: 20px;">
            <div class="breadcrumbs" style="float: left;">
                <a href="${pageContext.request.contextPath}/schema/">Schema</a> &gt;
                <a href="${pageContext.request.contextPath}/schema/${breadcrumbSchemaClass}">${breadcrumbSchemaClass}</a> &gt;
                <a href="${pageContext.request.contextPath}/schema/objects/${breadcrumbSchemaClass}">Entries</a>
            </div>

            <div class="breadcrumbs" style="float: right;">
                <c:if test="${linkToDetailsPage}">
                    <a href="${pageContext.request.contextPath}/detail/${id}" class="goto-details-light">Go to Details</a>
                </c:if>
            </div>
        </div>
        <h3 class="details-title">
            ${map.get('displayName')}<c:catch><c:if test="${not empty map.get('speciesName')}"> [${map.get('speciesName')}]</c:if></c:catch>
        </h3>

        <div class="schema-div">
            <table class="schema-detail-table">
                <tbody>
                <c:forEach var="entry" items="${map}" varStatus="loopStatus">
                    <tr class="${loopStatus.index % 2 == 0 ? 'even' : 'odd'}">
                        <td style="width: 25%">${entry.key}</td>
                        <td style="width: 75%">
                            <c:choose>
                                <c:when test="${entry.value.getClass().getSimpleName() == 'String' ||
                                                    entry.value.getClass().getSimpleName() == 'Long'   ||
                                                    entry.value.getClass().getSimpleName() == 'Integer'   ||
                                                    entry.value.getClass().getSimpleName() == 'Date'   ||
                                                    entry.value.getClass().getSimpleName() == 'Boolean'}">
                                    <c:choose>
                                        <%-- add value into an anchor tag just to show as a link. it's generic we need this check --%>
                                        <c:when test="${fn:startsWith(entry.value, 'http://') || fn:startsWith(entry.value, 'https://')}">
                                            <a href="${entry.value}" title="${entry.value}">${entry.value}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:black"> ${entry.value} </span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${entry.value.getClass().getSimpleName() == 'StoichiometryObject'}">
                                    <c:set var="id" value="${list.getDbId()}"/>
                                    <c:if test="${!empty list.getStId()}">
                                        <c:set var="id" value="${list.getStId()}"/>
                                    </c:if>
                                    <c:if test="${entry.value.stoichiometry gt 1}">${entry.value.stoichiometry} &times; </c:if><a href="./${id}" title="${entry.value.object.getDisplayName()}">[${entry.value.object.getSchemaClass()}:${id}] ${entry.value.object.getDisplayName()}<c:catch><c:if test="${not empty list.getSpeciesName()}"> - ${list.getSpeciesName()}</c:if></c:catch></a>
                                </c:when>
                                <c:when test="${entry.value.getClass().getSimpleName() == 'ArrayList' ||
                                                entry.value.getClass().getSimpleName() == 'HashSet' ||
                                                entry.value.getClass().getSimpleName() == 'LinkedHashSet'}">
                                    <ul class="list overflow">
                                        <c:forEach var="list" items="${entry.value}">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${list.getClass().getSimpleName() == 'String' ||
                                                                        list.getClass().getSimpleName() == 'Long'   ||
                                                                        list.getClass().getSimpleName() == 'Integer'   ||
                                                                        list.getClass().getSimpleName() == 'Date'   ||
                                                                        list.getClass().getSimpleName() == 'Boolean'}">
                                                        <span style="color:black"> ${list} </span>
                                                    </c:when>
                                                    <c:when test="${list.getClass().getSimpleName() == 'StoichiometryObject'}">
                                                        <c:set var="id" value="${list.object.getDbId()}"/>
                                                        <c:if test="${!empty list.object.getStId()}">
                                                            <c:set var="id" value="${list.object.getStId()}"/>
                                                        </c:if>
                                                        <c:if test="${list.stoichiometry gt 1}"> <span title="Stoichiometry">${list.stoichiometry} &times;</span></c:if> <a href="./${id}" title="${list.object.getDisplayName()}">[${list.object.getSchemaClass()}:${id}] ${list.object.getDisplayName()}<c:catch><c:if test="${not empty list.getSpeciesName()}"> - ${list.getSpeciesName()}</c:if></c:catch> </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:catch>
                                                            <c:if test="${!empty list.getDbId()}">
                                                                <c:set var="id" value="${list.getDbId()}"/>
                                                                <c:if test="${!empty list.getStId()}">
                                                                    <c:set var="id" value="${list.getStId()}"/>
                                                                </c:if>
                                                                <a href="./${id}" title="${list.getDisplayName()}">[${list.getSchemaClass()}:${id}] ${list.getDisplayName()}<c:catch><c:if test="${not empty list.getSpeciesName()}"> - ${list.getSpeciesName()}</c:if></c:catch></a>
                                                            </c:if>
                                                        </c:catch>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:when>
                                <c:otherwise>
                                    <c:catch>
                                        <c:if test="${!empty entry.value.dbId}">
                                            <c:set var="id" value="${entry.value.dbId}"/>
                                            <c:if test="${!empty entry.value.stId}">
                                                <c:set var="id" value="${entry.value.stId}"/>
                                            </c:if>
                                            <a href="./${id}" title="${entry.value.getDisplayName()}">[${entry.value.getSchemaClass()}:${id}] ${entry.value.getDisplayName()}<c:catch><c:if test="${not empty list.getSpeciesName()}"> - ${list.getSpeciesName()}</c:if></c:catch></a>
                                        </c:if>
                                    </c:catch>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${not empty referrals}">
            <div style="margin-top:25px; font-size: larger; font-weight: bold">Referrals</div>
            <table class="schema-detail-table">
                <tbody>
                    <c:forEach var="entry" items="${referrals}" varStatus="loopStatus">
                        <tr class="${loopStatus.index % 2 == 0 ? 'even' : 'odd'}">
                            <td style="width: 25%; text-decoration: underline">(${entry.referral})</td>
                            <td style="width: 75%">
                                <ul class="list">
                                <c:forEach var="list" items="${entry.objects}">
                                    <c:if test="${!empty list.getDbId()}">
                                        <c:set var="id" value="${list.getDbId()}"/>
                                        <c:if test="${!empty list.getStId()}">
                                            <c:set var="id" value="${list.getStId()}"/>
                                        </c:if>
                                        <li><a href="./${id}" title="${list.getDisplayName()}">[${list.getSchemaClass()}:${id}] ${list.getDisplayName()}<c:catch><c:if test="${not empty list.getSpeciesName()}"> - ${list.getSpeciesName()}</c:if></c:catch></a></li>
                                    </c:if>
                                </c:forEach>
                                </ul>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            </c:if>
        </div>
    </div>
</div>
<div class="clear"></div>

</div>            <%--A weird thing to avoid problems--%>
<c:import url="../footer.jsp"/>