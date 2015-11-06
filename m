Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:59844 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752346AbbKFMjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 07:39:47 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>
Subject: [[linux-nfc] PATCH v2.0 0/3] *** ST95HF driver v2.0 ***
Date: Fri, 6 Nov 2015 07:38:15 -0500
Message-ID: <1446813498-22981-1-git-send-email-shikha.singh@st.com> (sfid-20151106_133950_202944_EE9CDEAA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New patch series of ST95HF Linux Driver v2.0

Changelog:

v2.0:
1.Address feedbacks from Samuel:
	i)Code improvement and code optimization
2.Address feedbacks from Lars Steubesand:
	i)Code improvement and code optimization
	ii)Bug fix : Kernel crash due to race between irq_thread_handler()
	and  st95hf_remove() is resolved.
3.Address feedback from Christophe Henri Ricard:
	i)Correction in file headers.

v1.0:
First release of ST95HF driver.   

Shikha Singh (3):
  NFC: digital: Type4A tags support
  driver: nfc: st95hf: ST NFC Transceiver support
  DT: bindings: net: nfc: ST95HF binding doc

 .../devicetree/bindings/net/nfc/st95hf.txt         |   48 +
 drivers/nfc/st95hf/Kconfig                         |   10 +
 drivers/nfc/st95hf/Makefile                        |    6 +
 drivers/nfc/st95hf/core.c                          | 1240 ++++++++++++++++++++
 drivers/nfc/st95hf/spi.c                           |  168 +++
 drivers/nfc/st95hf/spi.h                           |   58 +
 net/nfc/digital_core.c                             |    3 +-
 7 files changed, 1532 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt
 create mode 100644 drivers/nfc/st95hf/Kconfig
 create mode 100644 drivers/nfc/st95hf/Makefile
 create mode 100644 drivers/nfc/st95hf/core.c
 create mode 100644 drivers/nfc/st95hf/spi.c
 create mode 100644 drivers/nfc/st95hf/spi.h

-- 
1.8.2.1

