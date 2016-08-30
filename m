Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.lairdtech.com ([63.123.150.69]:7815 "EHLO
        webmail.lairdtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbcH3OjP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 10:39:15 -0400
From: Dan Kephart <Dan.Kephart@lairdtech.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "engineering@keppy.com" <engineering@keppy.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: enable firmware crash dumps on the AR6004
Date: Tue, 30 Aug 2016 14:33:36 +0000
Message-ID: <F2BDA79A-DC91-43FD-9A35-FC6E36B2D37C@lairdtech.com> (sfid-20160830_163919_570294_81E466FA)
References: <1472566303-32613-1-git-send-email-dan.kephart@lairdtech.com>
 <871t16e34f.fsf@qca.qualcomm.com>
In-Reply-To: <871t16e34f.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

U29ycnkgS2FsbGUsIEkgZGlkIG5vdCBpbnRlbmQgdG8gcmUtc2VuZCB0aGlzIHBhdGNoIHVwLCBp
dCBpcyB0aGUgc2FtZSBhcyB0aGUgcHJldmlvdXMgb25lLg0KDQoNCk9uIDgvMzAvMTYsIDEwOjE5
IEFNLCAibGludXgtd2lyZWxlc3Mtb3duZXJAdmdlci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBW
YWxvLCBLYWxsZSIgPGxpbnV4LXdpcmVsZXNzLW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhh
bGYgb2Yga3ZhbG9AcWNhLnF1YWxjb21tLmNvbT4gd3JvdGU6DQoNCiAgICBlbmdpbmVlcmluZ0Br
ZXBweS5jb20gd3JpdGVzOg0KICAgIA0KICAgID4gRnJvbTogRGFuIEtlcGhhcnQgPGRhbi5rZXBo
YXJ0QGxhaXJkdGVjaC5jb20+DQogICAgPg0KICAgID4gVGhlIGZpcm13YXJlIGNyYXNoIGR1bXBz
IG9uIHRoZSA2MDA0IGFyZSB0aGUgc2FtZSBhcyB0aGUgNjAwMy4gUmVtb3ZlIHRoZQ0KICAgID4g
c3RhdGVtZW50IGd1YXJkaW5nIGl0IGZyb20gZHVtcGluZyBvbiB0aGUgNjAwNC4gIFJlbmFtZWQg
dGhlDQogICAgPiBSRUdfRFVNUF9DT1VOVF9BUjYwMDMgdG8gcmVmbGVjdCBzdXBwb3J0IG9uIGJv
dGggY2hpcHMuDQogICAgPg0KICAgID4gU2lnbmVkLW9mZi1ieTogRGFuIEtlcGhhcnQgPGRhbi5r
ZXBoYXJ0QGxhaXJkdGVjaC5jb20+DQogICAgDQogICAgSSBoYXZlIGEgc2ltaWxhciBwYXRjaCBh
bHJlYWR5IG9uIG15IHF1ZXVlOg0KICAgIA0KICAgIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5v
cmcvcGF0Y2gvOTI2MjI4OS8NCiAgICANCiAgICBIb3cgZG9lcyB0aGlzIGRpZmZlciBmcm9tIHRo
YXQ/IFBsZWFzZSBfYWx3YXlzXyBhZGQgYSBjaGFuZ2Vsb2cgc28gdGhhdA0KICAgIHBlb3BsZSBr
bm93IHdoYXQgaGFzIGNoYW5nZWQuIEFsc28gcmVtZW1iZXIgdG8gYWRkICJbUEFUQ0ggdjJdIiB0
byB0aGUNCiAgICB0aXRsZS4NCiAgICANCiAgICBodHRwczovL3dpcmVsZXNzLndpa2kua2VybmVs
Lm9yZy9lbi9kZXZlbG9wZXJzL2RvY3VtZW50YXRpb24vc3VibWl0dGluZ3BhdGNoZXMjc3ViamVj
dF9uYW1lDQogICAgDQogICAgLS0gDQogICAgS2FsbGUgVmFsbw0KDQoNCg==
