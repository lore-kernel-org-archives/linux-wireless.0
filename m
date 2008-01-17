Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:21723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbYAQKKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 05:10:41 -0500
Received: by fg-out-1718.google.com with SMTP id e21so619310fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 02:10:40 -0800 (PST)
Message-ID: <3e17ce20801170210t356f232bp6aca917e81062db3@mail.gmail.com> (sfid-20080117_101045_455103_75229103)
Date: Thu, 17 Jan 2008 11:10:39 +0100
From: "Marc Herbert" <marc.herbert@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: [PATCH] compat-2.6: fix "make unload" / ieee80211_crypt_tkip
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_23983_4559098.1200564639817"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_23983_4559098.1200564639817
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there,

I need this one-line patch for "make unload" to work on my Ubuntu gutsy.

The actual reason is beyond me, but I'm sure one of you will figure it
out and fix my fix in case it's not "the right thing".

Cheers,

Marc.

------=_Part_23983_4559098.1200564639817
Content-Type: application/octet-stream; name=scripts_unload.sh.crypt.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fbj569ta
Content-Disposition: attachment; filename=scripts_unload.sh.crypt.patch

LS0tIHNjcmlwdHMvdW5sb2FkLnNoCTIwMDgvMDEvMTcgMDk6NTk6MjgJMS4xCisrKyBzY3JpcHRz
L3VubG9hZC5zaAkyMDA4LzAxLzE3IDEwOjAwOjI0CkBAIC02LDYgKzYsNyBAQAogTU9EVUxFUz0i
JE9MRF9NT0RVTEVTIgogTU9EVUxFUz0iJE1PRFVMRVMgaXB3MjEwMCBpcHcyMjAwIgogTU9EVUxF
Uz0iJE1PRFVMRVMgbGliZXJ0YXNfY3MgdXNiOHh4eCBsaWJlcnRhcyIKK01PRFVMRVM9IiRNT0RV
TEVTIGllZWU4MDIxMV9jcnlwdF90a2lwIGllZWU4MDIxMV9jcnlwdF9jY21wIgogTU9EVUxFUz0i
JE1PRFVMRVMgaWVlZTgwMjExc29mdG1hYyBpZWVlODAyMTFfY3J5cHQgaWVlZTgwMjExIgogTU9E
VUxFUz0iJE1PRFVMRVMgYWRtODIxMSIKIE1PRFVMRVM9IiRNT0RVTEVTIGI0MyBiNDNsZWdhY3ki
Cg==
------=_Part_23983_4559098.1200564639817--
