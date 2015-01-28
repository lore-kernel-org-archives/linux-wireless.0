Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ssl.serverraum.org ([88.198.40.39]:43702 "EHLO
	ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbbA2CGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 21:06:42 -0500
Received: from localhost (localhost [127.0.0.1])
	by ssl.serverraum.org (Postfix) with ESMTP id 70B9D3F12F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2015 08:20:11 +0100 (CET)
Received: from ssl.serverraum.org ([127.0.0.1])
	by localhost (ssl.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gq72wcpJr4c9 for <linux-wireless@vger.kernel.org>;
	Wed, 28 Jan 2015 08:20:11 +0100 (CET)
Received: from [192.168.0.14] (123202036015.ctinets.com [123.202.36.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by ssl.serverraum.org (Postfix) with ESMTPSA id 8CD0D3F12E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2015 08:20:10 +0100 (CET)
Message-ID: <54C88C7D.707@m-labs.hk> (sfid-20150129_030648_640750_BD36A0BA)
Date: Wed, 28 Jan 2015 15:15:09 +0800
From: =?UTF-8?B?U8OpYmFzdGllbiBCb3VyZGVhdWR1Y3E=?= <sb@m-labs.hk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: "brcmfmac: brcmf_sdio_htclk: HT Avail timeout" on Thinkpad Tablet
 10
Content-Type: multipart/mixed;
 boundary="------------040105010002040305010606"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040105010002040305010606
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi,

The Lenovo Thinkpad Tablet 10 is a complete disaster under Linux, and
among many problems the SDIO brcmfmac wifi does not work.

I get the following messages in the kernel log:
brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init done
for chip 4324 rev 6 pmurev 17
brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[repeated]

and the network interface is never created.

I'm running kernel 3.18.4, my brcmfmac43241b4-sdio.bin is identical to
the one in the linux-firmware repository, and I have attached the
brcmfmac43241b4-sdio.txt that I have extracted from the EFI variables.

Any help would be appreciated.

Sébastien

--------------040105010002040305010606
Content-Type: text/plain; charset=UTF-8;
 name="brcmfmac43241b4-sdio.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="brcmfmac43241b4-sdio.txt"

Iy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KIyBOVlJBTSBmaWxlIGZvciBCQ000MzI0IHdpdGggMi40RyBhbmQgNUcg
ZXh0ZXJuYWwgUEFzLi4NCiMgUmVsZWFzZSBWZXJzaW9uOiBmb3g3N2g1MDZudnJhbS1FbGxh
LVdvcmxkV2lkZS12MDINCiMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCmRldmlkPTB4NDM3NA0KYm9hcmR0eXBlPTB4
NjdlDQpib2FyZHJldj0weDEzMDENCmJvYXJkZmxhZ3M9MHg5MDAwMTIwMA0KYm9hcmRmbGFn
czI9MA0KbWFjYWRkcj0wMDo5MDo0YzpjNToxMjozOA0Kc3JvbXJldj05DQp4dGFsZnJlcT0z
NzQwMA0Kbm9jcmM9MQ0KYWcwPTB4Mg0KYWcxPTB4Mg0KYWcyPTB4ZmYNCmFnMz0weGZmDQp0
eGNoYWluPTB4Mw0KcnhjaGFpbj0weDMNCmFhMmc9Mw0KYWE1Zz0zDQpjY29kZT1YVA0KcmVn
cmV2PTMxDQpsZWRiaDA9MHhmZg0KbGVkYmgxPTB4ZmYNCmxlZGJoMj0weGZmDQpsZWRiaDM9
MHhmZg0KbGVkZGM9MHhmZmZmDQojTVAgT3JpZ2luYWwgYm9hcmQgUEEgcGFyYW1ldGVyczoN
CnBhMmd3MGEwPTB4ZmZhNw0KcGEyZ3cxYTA9MHgxNTYzDQpwYTJndzJhMD0weGZlYjkNCiNN
UCBPcmlnaW5hbCBib2FyZCBQQSBwYXJhbWV0ZXJzOg0KcGEyZ3cwYTE9MHhmZjljDQpwYTJn
dzFhMT0weDEzNWUNCnBhMmd3MmExPTB4ZmViZg0KbWF4cDJnYTA9ODANCm1heHAyZ2ExPTgw
DQptYXhwNWdhMD03Ng0KbWF4cDVnYTE9NzYNCm1heHA1Z2hhMD03Ng0KbWF4cDVnaGExPTc2
DQptYXhwNWdsYTA9NzYNCm1heHA1Z2xhMT03Ng0KcGEwaXRzc2l0PTYyDQpwYTFpdHNzaXQ9
NjINCmFudHN3Y3RsMmc9MzANCmFudHN3Y3RsNWc9MzANCmFudHN3aXRjaD0weDANCnN1YmJh
bmQ1Z3Zlcj0wDQpwYTVndzBhMD0weGZmYTENCnBhNWd3MWEwPTB4MTE0ZA0KcGE1Z3cyYTA9
MHhmZWJmDQpwYTVndzBhMT0weGZmY2ENCnBhNWd3MWExPTB4MTFhYQ0KcGE1Z3cyYTE9MHhm
ZWVlDQpwYTVnbHcwYTA9MHhmZmIzDQpwYTVnbHcxYTA9MHgxMDgwDQpwYTVnbHcyYTA9MHhm
ZWQ0DQpwYTVnbHcwYTE9MHhmZmQ0DQpwYTVnbHcxYTE9MHgxMGFhDQpwYTVnbHcyYTE9MHhm
ZjAxDQpwYTVnaHcwYTA9MHhmZmFmDQpwYTVnaHcxYTA9MHgxMTZmDQpwYTVnaHcyYTA9MHhm
ZWU2DQpwYTVnaHcwYTE9MHhmZjljDQpwYTVnaHcxYTE9MHgxMGYzDQpwYTVnaHcyYTE9MHhm
ZWQ0DQpleHRwYWdhaW4yZz0zDQpleHRwYWdhaW41Zz0zDQpwZGV0cmFuZ2UyZz0yDQpwZGV0
cmFuZ2U1Zz0yDQp0cmlzbzJnPTMNCnRyaXNvNWc9MQ0KZWxuYTJnPTENCmVsbmFieXBhc3My
Zz0tOA0KZWxuYTVnPTENCmVsbmFieXBhc3M1Zz0tOA0KdHNzaXBvczJnPTENCnRzc2lwb3M1
Zz0xDQpjY2tidzIwMmdwbz0weDY2NjYNCmNja2J3MjB1bDJncG89MHg2NjY2DQpsZWdvZmRt
YncyMDJncG89MHg1NTUzMzMzMw0KbGVnb2ZkbWJ3MjB1bDJncG89MHg1NTUzMzMzMw0KbWNz
YncyMDJncG89MHg2NjY1NTU1NQ0KbWNzYncyMHVsMmdwbz0weDY2NjU1NTU1DQptY3NidzQw
Mmdwbz0weDY2NjU1NTU1DQptY3MzMnBvPTB4NTU1NQ0KbGVnNDBkdXAyZ3BvPTB4Mg0KbGVn
b2ZkbWJ3MjA1Z2xwbz0weDIyMjAwMDAwDQpsZWdvZmRtYncyMHVsNWdscG89MHg0NDQ0MjIy
Mg0KbGVnb2ZkbWJ3MjA1Z21wbz0weDIyMjAwMDAwDQpsZWdvZmRtYncyMHVsNWdtcG89MHg0
NDQ0MjIyMg0KbGVnb2ZkbWJ3MjA1Z2hwbz0weDIyMjAwMDAwDQpsZWdvZmRtYncyMHVsNWdo
cG89MHg0NDQ0MjIyMg0KbWNzYncyMDVnbHBvPTB4OTk5OTk5OTkNCm1jc2J3MjB1bDVnbHBv
PTB4OTk5OTk5OTkNCm1jc2J3NDA1Z2xwbz0weDQ0NDIyMjIyDQptY3NidzIwNWdtcG89MHg2
NjY2NjY2Ng0KbWNzYncyMHVsNWdtcG89MHg2NjY2NjY2Ng0KbWNzYnc0MDVnbXBvPTB4NDQ0
MjIyMjINCm1jc2J3MjA1Z2hwbz0weDY2NjY2NjY2DQptY3NidzIwdWw1Z2hwbz0weDY2NjY2
NjY2DQptY3NidzQwNWdocG89MHg0NDQyMjIyMg0KaXR0MmdhMD0weDIwDQppdHQ1Z2EwPTB4
M2UNCml0dDJnYTE9MHgyMA0KaXR0NWdhMT0weDNlDQp0ZW1wdGhyZXNoPTEyMA0Kb3RwaW1h
Z2VzaXplPTIzMg0KdXNiZXBudW09MHgyDQptdXhlbmFiPTB4NQ0Kbm9pc2VjYWxvZmZzZXQ9
MTINCm5vaXNlY2Fsb2Zmc2V0NWc9MTINClB3ck9mZnNldGNjaz0weDAwMDYNClB3ck9mZnNl
dDQwbWh6NWc9MHg5DQp0eGlkeGNhcDJnPTANCnR4aWR4Y2FwNWc9MA0KVHNzaUF2NWc9MHgw
DQpUc3NpVm1pZDVnPTB4OUMNClRzc2lBdjJnPTB4MA0KVHNzaVZtaWQyZz0weEFBDQojT3V0
LW9mLWJhbmQgR1BJTyBXYWtldXANCnNkX2dwb3V0PTANCnNkX2dwdmFsPTENCnNkX2dwZGM9
MA0KI1dpRmkvQlQgY28tZXhpc3RlbmNlIHBhcmFtZXRlcg0KYnRjX21vZGU9NQ0KYnRjX3Bh
cmFtczk9MTUwMDAK
--------------040105010002040305010606--
