Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slackware.com ([64.57.102.34]:44112 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYKSFEQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 00:04:16 -0500
Date: Tue, 18 Nov 2008 20:18:24 -0800 (PST)
From: Robby Workman <rworkman@slackware.com>
To: linux-wireless@vger.kernel.org
cc: antiwire@gmail.com
Subject: [PATCH] iw: Makefile changes for easier packaging
Message-ID: <alpine.LNX.1.10.0811182015230.6923@bob.slackware.com> (sfid-20081119_060422_947202_BBB99A28)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="960504422-1975104624-1227068304=:6923"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--960504422-1975104624-1227068304=:6923
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

Attached is a trivial patch to make packaging a bit easier.
No strong feelings either way, so rejection will cause no
hard feelings :-)

-RW
--960504422-1975104624-1227068304=:6923
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=iw-Makefile.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.1.10.0811182018240.6923@bob.slackware.com>
Content-Description: 
Content-Disposition: attachment; filename=iw-Makefile.diff

VHJpdmlhbCBwYXRjaCBmb3IgZWFzaWVyIHBhY2thZ2luZyBvZiBpdw0KU2ln
bmVkLW9mZi1ieTogUm9iYnkgV29ya21hbiA8cndvcmttYW5Ac2xhY2t3YXJl
LmNvbT4NCi0tLQ0KZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUN
CmluZGV4IDNmYTBhODMuLmRmNTliNTEgMTAwNjQ0DQotLS0gYS9NYWtlZmls
ZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0yLDEwICsyLDE0IEBADQogDQogTUFL
RUZMQUdTICs9IC0tbm8tcHJpbnQtZGlyZWN0b3J5DQogDQorUFJFRklYID89
IC91c3INCitCSU5ESVIgPz0gJChQUkVGSVgpL2Jpbg0KK01BTkRJUiA/PSAk
KFBSRUZJWCkvc2hhcmUvbWFuDQorDQogTUtESVIgPz0gbWtkaXIgLXANCiBJ
TlNUQUxMID89IGluc3RhbGwNCi1QUkVGSVggPz0gL3Vzcg0KIENDID89ICJn
Y2MiDQorDQogQ0ZMQUdTICs9IC1XYWxsIC1XdW5kZWYgLVdzdHJpY3QtcHJv
dG90eXBlcyAtV25vLXRyaWdyYXBocyAtZm5vLXN0cmljdC1hbGlhc2luZyAt
Zm5vLWNvbW1vbiAtV2Vycm9yLWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0
aW9uIGBwa2ctY29uZmlnIC0tY2ZsYWdzIGxpYm5sLTFgDQogQ0ZMQUdTICs9
IC1PMiAtZw0KIExERkxBR1MgKz0gYHBrZy1jb25maWcgLS1saWJzIGxpYm5s
LTFgDQpAQCAtNDksMTEgKzUzLDExIEBAIGNoZWNrOg0KIA0KIGluc3RhbGw6
IGl3IGl3LjguZ3oNCiAJQCQoTlEpICcgSU5TVCBpdycNCi0JJChRKSQoTUtE
SVIpICQoREVTVERJUikkKFBSRUZJWCkvYmluLw0KLQkkKFEpJChJTlNUQUxM
KSAtbSA3NTUgLW8gcm9vdCAtZyByb290IC10ICQoREVTVERJUikkKFBSRUZJ
WCkvYmluLyBpdw0KKwkkKFEpJChNS0RJUikgJChERVNURElSKSQoQklORElS
KQ0KKwkkKFEpJChJTlNUQUxMKSAtbSA3NTUgLXQgJChERVNURElSKSQoQklO
RElSKSBpdw0KIAlAJChOUSkgJyBJTlNUIGl3LjgnDQotCSQoUSkkKE1LRElS
KSAkKERFU1RESVIpJChQUkVGSVgpL3NoYXJlL21hbi9tYW44Lw0KLQkkKFEp
JChJTlNUQUxMKSAtbSA2NDQgLW8gcm9vdCAtZyByb290IC10ICQoREVTVERJ
UikkKFBSRUZJWCkvc2hhcmUvbWFuL21hbjgvIGl3LjguZ3oNCisJJChRKSQo
TUtESVIpICQoREVTVERJUikkKE1BTkRJUikvbWFuOC8NCisJJChRKSQoSU5T
VEFMTCkgLW0gNjQ0IC10ICQoREVTVERJUikkKE1BTkRJUikvbWFuOC8gaXcu
OC5neg0KIA0KIGNsZWFuOg0KIAkkKFEpcm0gLWYgaXcgKi5vICp+ICouZ3og
dmVyc2lvbi5oICotc3RhbXANCg==

--960504422-1975104624-1227068304=:6923--
