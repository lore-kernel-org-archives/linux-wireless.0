Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10551 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbdJ2T6U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 15:58:20 -0400
From: Maya Haim <merez@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        qca_merez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        QCA_ailizaro <QCA_ailizaro@QCA.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>,
        qca_merez <qca_merez@qca.qualcomm.com>
Subject: RE: [01/12] wil6210: run-time PM when interface down
Date: Sun, 29 Oct 2017 19:58:15 +0000
Message-ID: <6dab086844a74a32990ef682a484c425@euamsexm01a.eu.qualcomm.com> (sfid-20171029_205842_253620_D2E3731D)
References: <1508937247-11890-2-git-send-email-qca_merez@qca.qualcomm.com>
 <589009024f344a718e1616b30dd3edd0@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <589009024f344a718e1616b30dd3edd0@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

S2FsbGUgVmFsbyA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+IHdyb3RlOg0KDQo+IE1heWEgRXJleiA8
cWNhX21lcmV6QHFjYS5xdWFsY29tbS5jb20+IHdyb3RlOg0KDQo+PiBBbGxvdyBydW4tdGltZSBz
dXNwZW5kIHdoZW4gaW50ZXJmYWNlIGlzIGRvd24sIGtlZXAgY2FyZCBhbGl2ZSB3aGVuIA0KPj4g
aW50ZXJmYWNlIGlzIHVwLg0KPj4gSWYgZHJpdmVyIGlzIGluIHdtaSBvbmx5IG9yIGRlYnVnX2Z3
IG1vZGUgcnVuLXRpbWUgUE0gd29uJ3Qgc3VzcGVuZC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBM
YXphciBBbGV4ZWkgPHFjYV9haWxpemFyb0BxY2EucXVhbGNvbW0uY29tPg0KPj4gCXBjaWVfYnVz
LmMNCj4+IFNpZ25lZC1vZmYtYnk6IE1heWEgRXJleiA8cWNhX21lcmV6QHFjYS5xdWFsY29tbS5j
b20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBLYWxsZSBWYWxvIDxrdmFsb0BxY2EucXVhbGNvbW0uY29t
Pg0KDQo+IEtidWlsZCBib3QgZm91bmQgcHJvYmxlbXM6DQoNClRoYW5rcywgS2FsbGUuIFdlIHdp
bGwgZml4IHRoZSBlcnJvcnMuDQo=
