Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:53975 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbbLVJyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 04:54:24 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc] PATCH v1.0 0/1] ST95HF:Fix build err
Date: Tue, 22 Dec 2015 04:53:36 -0500
Message-ID: <1450778017-12124-1-git-send-email-shikha.singh@st.com> (sfid-20151222_105431_197682_10B26EFB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modification in st95hf/core.c to resolve build error.
Patch contains only delta in core.c to fix build error
assuming original series of ST95HF driver is already 
applied on NFC-next master branch. 

Shikha Singh (1):
  driver: nfc: st95hf: Fix of build error

 drivers/nfc/st95hf/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.2.1

