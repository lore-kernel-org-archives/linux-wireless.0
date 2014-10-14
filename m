Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36147 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbaJNHIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 03:08:09 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Belisko Marek <marek.belisko@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 14 Oct 2014 00:08:00 -0700
Subject: RE: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected
 to 5GHz
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com> (sfid-20141014_090822_383584_FE8ED9A5)
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
 <CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
In-Reply-To: <CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_5FF020A1CFFEEC49BD1E09530C4FF5951821936F03SCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_5FF020A1CFFEEC49BD1E09530C4FF5951821936F03SCVEXCH1marve_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgTWFyZWssDQoNCj5JIHRyaWVkIGJvdGggKHNsaWdodGx5IG1vZGlmaWVkIGFzIHdlJ3JlIGlu
IDMuOSBrZXJuZWwpIGJ1dCBpc3N1ZSBpcw0KPnN0aWxsIHJlcHJvZHVjaWJsZS4gTXkgcGF0Y2gg
YWdhaW5zdCAzLjkgc291cmNlczoNCg0KVGhhbmtzIGEgbG90IGZvciB0aGUgdGVzdHMuDQoNCj5P
bmUgdGhpbmcgd2hpY2ggaXMgbm90IHlldCBzdGlsbCBjbGVhciB0byBtZSB3aHkga2VybmVsIGNv
bnNvbGUgaXMNCj5jb21wbGV0ZWx5IHVucmVzcG9uc2l2ZSB3aGVuIHJlY2VpdmluZyBwYWNrZXRz
IGluIGhpZ2ggcmF0ZXMuIFdoZW4gdXNlDQo+aXBlcmYgKG9uIGNsaWVudCkgd2l0aCAtYjQwbSBp
dCBpcyBPSyBidXQgd2hlbiBpbmNyZWFzZSB0byAtYjEwMG0gdGhlbg0KPmNvbnNvbGUgaXMgY29t
cGxldGVseSB1bnJlc3BvbnNpdmUgdW50aWwgaXBlcmYgZmluaXNoLiANCg0KRG9lcyB0aGUgc3lz
dGVtIHJlY292ZXIgd2hlbiAiLWIxMDBNIiBpcGVyZiBpcyBmaW5pc2hlZD8gQ2FuIHdlIHJ1biBp
cGVyZiB3aXRoICItYjQwTSIgbGF0ZXI/DQpEbyB5b3Ugc2VlICJkZXZfYWxsb2Nfc2tiIGZhaWxl
ZCIgbWVzc2FnZXMgaW4gZG1lc2cgd2hlbiBjb25zb2xlIGlzIHVucmVzcG9uc2l2ZT8NCg0KPkFu
eSBvdGhlciBpZGVhcw0KPndoYXQgdG8gY2hhbmdlIHRvIGNoZWNrPyBUaGFua3MuDQoNCkNvdWxk
IHlvdSBwbGVhc2Ugc2hhcmUgZG1lc2cgbG9nIHdpdGggZHluYW1pYyBkZWJ1ZyBlbmFibGVkICh1
c2luZyBhdHRhY2hlZCBzY3JpcHQpIGNhcHR1cmVkIHdoZW4gdGhlIHByb2JsZW0gb2NjdXJzPw0K
DQpCZXN0IHJlZ2FyZHMsDQpBbWl0DQo=

--_002_5FF020A1CFFEEC49BD1E09530C4FF5951821936F03SCVEXCH1marve_
Content-Type: application/octet-stream; name="mwifiex_dynamic_debug.sh"
Content-Description: mwifiex_dynamic_debug.sh
Content-Disposition: attachment; filename="mwifiex_dynamic_debug.sh";
	size=429; creation-date="Tue, 14 Oct 2014 06:55:49 GMT";
	modification-date="Tue, 14 Oct 2014 07:06:04 GMT"
Content-Transfer-Encoding: base64

IyBUaGlzIHNjcmlwdCBlbmFibGVzIGRlYnVnIGxvZ3MgZm9yIG13aWZpZXggZHJpdmVyLgojIE1h
a2Ugc3VyZSB0aGF0IGR5bmFtaWMgZGVidWcgaXMgZW5hYmxlIGluIHlvdXIga2VybmVsIGNvbmZp
Z3VyYXRpb24gKENPTkZJR19EWU5BTUlDX0RFQlVHPXkpCm1vdW50IC10IGRlYnVnZnMgZGVidWdm
cyAvZGVidWdmcwplY2hvICJtb2R1bGUgbXdpZmlleCArcCIgPiAvZGVidWdmcy9keW5hbWljX2Rl
YnVnL2NvbnRyb2wKZWNobyAibW9kdWxlIG13aWZpZXhfcGNpZSArcCIgPiAvZGVidWdmcy9keW5h
bWljX2RlYnVnL2NvbnRyb2wKZWNobyAibW9kdWxlIG13aWZpZXhfdXNiICtwIiA+IC9kZWJ1Z2Zz
L2R5bmFtaWNfZGVidWcvY29udHJvbAplY2hvICJtb2R1bGUgbXdpZmlleF9zZGlvICtwIiA+IC9k
ZWJ1Z2ZzL2R5bmFtaWNfZGVidWcvY29udHJvbAoK

--_002_5FF020A1CFFEEC49BD1E09530C4FF5951821936F03SCVEXCH1marve_--
