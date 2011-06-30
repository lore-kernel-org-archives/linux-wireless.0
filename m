Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58130 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1F3Gm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 02:42:57 -0400
Received: by pvg12 with SMTP id 12so1344488pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 23:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309385518-12097-4-git-send-email-hauke@hauke-m.de>
References: <1309385518-12097-1-git-send-email-hauke@hauke-m.de>
	<1309385518-12097-4-git-send-email-hauke@hauke-m.de>
Date: Thu, 30 Jun 2011 08:42:56 +0200
Message-ID: <BANLkTimAE-xphUYeMMzzz6B531tedo6Vkw@mail.gmail.com> (sfid-20110630_084337_264025_23F48F7D)
Subject: Re: [RFC v3 03/13] bcma: add functions to scan cores needed on SoCs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MjAxMS82LzMwIEhhdWtlIE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPjoKPiArIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGNvcmUtPmNvcmVfaW5kZXggPSBjb3JlX251bSsrOwo+ICsgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgYnVzLT5ucl9jb3JlcysrOwo+ICsKPiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oHByX2luZm8oIkNvcmUgJWQgZm91bmQ6ICVzICIKPiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCIobWFudWYgMHglMDNYLCBpZCAweCUwM1gsIHJldiAweCUwMlgsIGNsYXNzIDB4
JVgpXG4iLAo+IC0gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYnVzLT5ucl9jb3Jl
cywgYmNtYV9kZXZpY2VfbmFtZSgmY29yZS0+aWQpLAo+ICsgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgY29yZS0+Y29yZV9pbmRleCwgYmNtYV9kZXZpY2VfbmFtZSgmY29yZS0+aWQp
LAo+IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29yZS0+aWQubWFudWYsIGNv
cmUtPmlkLmlkLCBjb3JlLT5pZC5yZXYsCj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBjb3JlLT5pZC5jbGFzcyk7Cj4KPiAtIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvcmUtPmNv
cmVfaW5kZXggPSBidXMtPm5yX2NvcmVzKys7Cj4gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBsaXN0
X2FkZCgmY29yZS0+bGlzdCwgJmJ1cy0+Y29yZXMpOwoKRGlkbid0IHlvdSBqdXN0IGNoYW5nZSBj
b3JlIGluZGV4ZXMgKDAsIDEsIC4uLikgdG8gbnVtYmVycyAoMSwgMiwKLi4uKT8gSXQgd291bGQg
YnJlYWsgZW5hYmxpbmcgSVJRcyBvbiBQQ0kuCgpEaWRuJ3QgdGVzdCBpdCBob3dldmVyIHlldCwg
SSdsbCBoYXZlIGFjY2VzcyB0byBteSBtYWNoaW5lcyB0b21vcnJvdy4KCi0tIApSYWZhxYIK
