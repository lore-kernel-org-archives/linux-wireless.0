Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab3KJMRu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 07:17:50 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: wzyboy <wzyboy@wzyboy.org>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Sun, 10 Nov 2013 12:17:33 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DEDBCB@HASMSX103.ger.corp.intel.com> (sfid-20131110_131754_574280_447BC390)
References: <5276134B.8070808@wzyboy.org>
 <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
 <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
 <CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
 <CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com>
 <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CAErSpo6ry6cUaVngozS8-P44=LPJN6cbsZ_mfWkJv9Rn85YXUQ@mail.gmail.com>
 <CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
 <CANUX_P33UqkCsfHrJW+gx-ZbEQduJ1EZ59fpx6T6wQWOLufSqg@mail.gmail.com>
 <CALkVjQYNPXpTjUpR9NZU6MTJhUmYeO1jXWvOOxk8-Pm=xdKZLg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEDB31@HASMSX103.ger.corp.intel.com>
 <CALkVjQbkZSvhbEAwEK-LQGjKX6kdvAMB1UUuFuW3GGO60r0wKQ@mail.gmail.com>
In-Reply-To: <CALkVjQbkZSvhbEAwEK-LQGjKX6kdvAMB1UUuFuW3GGO60r0wKQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiANCj4gMjAxMy8xMS8xMCBHcnVtYmFjaCwgRW1tYW51ZWwgPGVtbWFudWVsLmdydW1iYWNoQGlu
dGVsLmNvbT46DQo+ID4gSXQgaXMgcmVhbGx5IGNhbGxlZCBMMSBQTSBTdWJzdGF0ZS4NCj4gPiBJ
IGRvbid0IHJlYWxseSBrbm93IHRoZSBCSU9TIG9mIFRoaW5rUGFkLi4uIEJ1dCB3ZSBjYW4gdHJ5
Li4uDQo+IA0KPiANCj4gSSBoYXZlIGJvb3RlZCBpbnRvIEJJT1MgYW5kIHdyaXRlIGRvd24gYWxt
b3N0IGFsbCB0aGUgb3B0aW9ucywgYXMgYXR0YWNoZWQuDQo+IA0KPiBCeSB0aGUgd2F5LCBJIGFs
d2F5cyBhdHRhY2ggbXkgbGFwdG9wIHRvIGFuIEFDIGFkYXB0b3IuDQo+IA0KDQpDb29sLi4uLiB0
aGV5IG1hc2sgYWxsIHRoZSBpbnRlcmVzdGluZyBvcHRpb25zLi4uIG9oIHdlbGwuLi4NCg==
