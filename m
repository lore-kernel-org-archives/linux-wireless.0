Received: from mx0a-00617f01.pphosted.com (mx0a-00617f01.pphosted.com [205.220.165.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ABF4A64F6
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 10:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370333; cv=none; b=GeP7VKg54XTtVB+hm7CO9pEjBgVrba8JUBOzt7OzjUgPknCJDY3sLOT0rmczUAfjtozWd6Eiy5I4LTtrkp3VTOyxRngc427OXTEKGXX0dfC1aFiQtxIKX0JUgViWREqCmYRdB6WauVf3nKDbQcbDrv199qVFrlNevxfAvUFzKqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370333; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G6+7Q/R6C4rO7igVy50zwnnKi4m4mYSsVKFhzqBw5ax1qa/WgpeLlNimc7D+GtrM5/F4PDVfSojE9Adq2lbiqDBB1rBEqzhD2J6WTX1rvh9iZpui6xl2jW6Oan3ccGykh6k8RHuYrJQiRha1OOViwaf5eX0u8CFNCX3GCGpy6J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=psmicorp.com; spf=pass smtp.mailfrom=psmicorp.com; arc=none smtp.client-ip=205.220.165.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=psmicorp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=psmicorp.com
Received: from pps.filterd (m0247527.ppops.net [127.0.0.1])
	by mx0a-00617f01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697002oI3309987
	for <linux-wireless@vger.kernel.org>; Tue, 6 Oct 2026 20:07:58 -0400
Received: from egc-exch2.psmicorp.com (webmail.psmicorp.com [38.142.134.66] (may be forged))
	by mx0a-00617f01.pphosted.com (PPS) with ESMTPS id 4h5b5e00p6-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 20:07:58 -0400 (EDT)
Received: from EGC-EXCH2.psmicorp.com (10.1.1.111) by EGC-EXCH2.psmicorp.com
 (10.1.1.111) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.61; Tue, 6 Oct
 2026 17:55:52 -0400
Received: from psmicorp.com (10.1.1.107) by EGC-EXCH2.psmicorp.com
 (10.1.1.111) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.2507.61 via Frontend
 Transport; Tue, 6 Oct 2026 17:55:51 -0400
Reply-To: <greg@gospelmusicuniversity.com>
From: Evans Thomas <_us@psmicorp.com>
To: <linux-wireless@vger.kernel.org>
Subject: fund transfer opportunity,Reply..
Date: Tue, 6 Oct 2026 23:55:49 +0200
Message-ID: <20261006235549.FD045281E94DB49A@psmicorp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: RjBl6EbcslyXMzgu_f8-GIJzFjy4ZnVU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX3kc5/lUFmoaO
 DtDmk77AiH03i6ajrPuYMnGDMnxKNsPBZ7DzRmF734a8JBHt7mC7v+cgm/dOdbjS1oXNMOZOowF
 9nBq0CcwcqllZ5pPJaDgLstTHYVNB0OC1F55kUyl4FMTnF93dXnV6Z3hvPsdK3ZNUBEpAj6EgaA
 zKQ7MEpEdekD2QnyxsvjAmG3YyzREPnZ7OVZlsH0+q6ZLXun8T5Qvg6aCgi5mrEQMQBoknbrlmm
 jJbSOthJijrX+LiDmLpYmrNWn3QpTS48h5pEGWCbN72MsQULeCwt3V0CmA2DOOrO8B8to3mUjUA
 KGeb0zIRoqk4mTodBDUXfJWpbj4M/SdPxzjQsgKPS4K7SIcWxRlSxgt7kM8/ta4N1q0L8HB12L2
 hkG54kuKkQ9MDhFy4EzFXa0xMDcinp7O05vW3rper85I4ICixHnSmryAV5OC6LvCpQks8R0WYYr
 gsTQ0BvvdqJQzbBOhfw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX73MxJ3BuZivp
 CtfNRrRF6yKWMo79by0+Vptcup8Jk+aGITeMsNmMiH5wWKTpclunTYsFbaoAit8KAu5fTlqQLCR
 VSDA+TA8oxfe6Ry9wYM5xucT9ZK+osEr9IZ1TVa825NVUJP+iGDx
X-Authority-Analysis: v=2.4 cv=GvTXaU1C c=1 sm=1 tr=0 ts=6ac58d5e cx=c_pps
 a=sNj4pI0fii9qGHoVqNzRVg==:117 a=sNj4pI0fii9qGHoVqNzRVg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=ZHGAjPH774soz-f4Le74:22
 a=GfZueQGhKz3ujf-POmTq:22 a=tclcd6dtLQvEqt9_mmAA:9
X-Proofpoint-ORIG-GUID: RjBl6EbcslyXMzgu_f8-GIJzFjy4ZnVU
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610070000

