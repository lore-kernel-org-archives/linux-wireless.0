Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:50201 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753003Ab1EXRdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 13:33:05 -0400
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: multipart/mixed; boundary="========GMX24961306258381917866"
Date: Tue, 24 May 2011 19:33:01 +0200
From: arne.fitzenreiter@gmx.de
Message-ID: <20110524173301.24960@gmx.net> (sfid-20110524_193312_937687_BC65E9E4)
MIME-Version: 1.0
Subject: [PATCH] compat: fix kfifo taint's kernel (missing license info)
To: mcgrof@kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX24961306258381917866
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

compat wireless kfifo modul has no MODULE_LICENSE. The kernel does'nt like this.

Sorry for the last empty mail...

-- 
Arne Fitzenreiter
----------------------------------------------
mailto:arne@fitzenreiter.de
http://www.fitzenreiter.de
ICQ: 285-193-731
----------------------------------------------
Tel: +49 179/8603400 (Mo-Do 17-22 Uhr)
Tel: +49 36337/18300 (Wochendende)
sip://493633718300@warriors.homedns.org
----------------------------------------------

Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de

--========GMX24961306258381917866
Content-Type: application/octet-stream;
 name="compat-wireless-2.6.39_kfifo_module_info.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="compat-wireless-2.6.39_kfifo_module_info.patch"

ZGlmZiAtTmF1ciBjb21wYXQtd2lyZWxlc3MtMi42LjM5LTEtc24ub3JnL2NvbXBhdC9rZmlmby5j
IGNvbXBhdC13aXJlbGVzcy0yLjYuMzktMS1zbi9jb21wYXQva2ZpZm8uYwotLS0gY29tcGF0LXdp
cmVsZXNzLTIuNi4zOS0xLXNuLm9yZy9jb21wYXQva2ZpZm8uYwkyMDExLTA1LTI0IDAxOjQzOjQ4
LjAwMDAwMDAwMCArMDIwMAorKysgY29tcGF0LXdpcmVsZXNzLTIuNi4zOS0xLXNuL2NvbXBhdC9r
Zmlmby5jCTIwMTEtMDUtMjQgMTc6MjA6MDYuOTU2ODE4MzEzICswMjAwCkBAIC0yNyw2ICsyNywx
MCBAQAogI2luY2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4KICNpbmNsdWRlIDxsaW51eC9rZmlmby5o
PgogCitNT0RVTEVfTElDRU5TRSgiR1BMIik7CitNT0RVTEVfQVVUSE9SKCJTdGVmYW5pIFNlaWJv
bGQgPHN0ZWZhbmlAc2VpYm9sZC5uZXQ+Iik7CitNT0RVTEVfREVTQ1JJUFRJT04oIkEgZ2VuZXJp
YyBrZXJuZWwgRklGTyBpbXBsZW1lbnRhdGlvbiIpOworCiAvKgogICogaW50ZXJuYWwgaGVscGVy
IHRvIGNhbGN1bGF0ZSB0aGUgdW51c2VkIGVsZW1lbnRzIGluIGEgZmlmbwogICovCg==
--========GMX24961306258381917866--
