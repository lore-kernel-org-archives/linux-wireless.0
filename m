Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47919 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbbGULUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 07:20:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZHVai-0007Xq-Vq
	for linux-wireless@vger.kernel.org; Tue, 21 Jul 2015 13:20:09 +0200
Received: from 192.198.151.44 ([192.198.151.44])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 13:20:03 +0200
Received: from doru.gucea by 192.198.151.44 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 13:20:03 +0200
To: linux-wireless@vger.kernel.org
From: Doru <doru.gucea@intel.com>
Subject: FW: Multiple Vifs in Managed Mode
Date: Tue, 21 Jul 2015 11:16:54 +0000 (UTC)
Message-ID: <loom.20150721T131536-749@post.gmane.org> (sfid-20150721_132015_629545_B094D01D)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGVsbG8sIEpvaGFubmVzCgpXaGF0IEkgdHJ5IHRvIGRvIGlzIHBlcmZlY3RseSAgZGVzY3JpYmVkIGluIHRoaXMgcGljdHVyZTogCmh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvMEI1U0JIMDhQVV9DaFNWVlFkRWhRUTI5bmVHOC92aWV3Pwp1c3A9c2hhcmluZwpJdOKAmXMgd29ydGggbWVudGlvbmluZyB0aGF0IEkgbmVlZCB0byBkbyB0aGlzIG9uIGFuIEFuZHJvaWQgcGhvbmUuIFRoZSAKcHJvYmxlbSBpcyB0aGF0IHRoZSBvbmx5IHJlc291cmNlcwpmb3IgZmluZGluZyBhIHNvbHV0aW9uIHNlZW1zIHRvIGJlIHRoaXMgbWFpbGluZyBsaXN0IGFuZCB0aGUgYXNzb2NpYXRlZCAKd2ViIHNpdGUgYnV0IHRoZSBpbmZvcm1hdGlvbiBpcyBwcmV0dHkKc2NhdHRlcmVkLiBGcm9tIHRoZSByZXNlYXJjaCBJ4oCZdmUgZG9uZSB1bnRpbCBub3csIHRoZSBtYWM4MDIxMSBsYXllciAKYWxyZWFkeSBoYXMgc3VwcG9ydCBmb3IgbXVsdGktdmlmcwpidXQgdGhpcyBpcyB1c2VsZXNzIGlmIHRoZSBkcml2ZXIgZG9lc27igJl0IHVzZSB0aGlzIGZ1bmN0aW9uYWxpdHkuCgpJIHRyaWVkIHRvIGNyZWF0ZSBtdWx0aXBsZSB2aWYgb24gMyBkaWZmZXJlbnQgQW5kcm9pZCBzbWFydHBob25lcyAoTmV4dXMgCjUsIE5leHVzIFMsIFNhbXN1bmcgR2FsYXh5IFM0KSBidXQgCmFsbCBvZiB0aGVtIGFsbG93ZWQgbWUgdG8gY3JlYXRlIG9ubHkgb25lIHZpZi4gVGhlIGRyaXZlciB1c2VkIGluIHRoaXMgCmNhc2UgaXMgdGhlIG9uZSBmcm9tIApkcml2ZXJzL25ldC93aXJlbGVzcy9iY21kaGQuIExvb2tpbmcgaW50byB0aGUgY29kZSBJIG5vdGljZWQgdGhhdCBhIAptYXhpbXVtIG9mIDMgaW50ZXJmYWNlcyBpbiB0aGUgbWFuYWdlZAptb2RlIGFyZSBhbGxvd2VkLiBBcyB0aGVyZSBhcmUgYWxyZWFkeSB0d28gaW50ZXJmYWNlcyBpbiB0aGUgbWFuYWdlZCAKbW9kZSAocDJwMCBhbmQgdGhlIHBoeXNpY2FsIFdpZmkgaW50ZXJmYWNlKSAKdGhlIGFib3ZlIGJlaGF2aW9yICBzZWVtcyB0byBiZSB0aGUgcmlnaHQgb25lLgoKTXkgcXVlc3Rpb24gaXM6IGZyb20geW91ciBrbm93bGVkZ2UgaXMgdGhlcmUgYW55IHdpcmVsZXNzIGRyaXZlciBmb3IgYSAKc21hcnRwaG9uZeKAmXMgV2lGaSBjaGlwc2V0IHdoaWNoIHN1cHBvcnRzIAptdWx0aXBsZSB2aWZzPyBJdCBkb2VzbuKAmXQgbWF0dGVyIGlmIHRoZSBkcml2ZXIgaXMgb3Blbi1zb3VyY2UgKGNhbiBiZSAKZm91bmQgaW4gdGhlIGRyaXZlcnMvbmV0L3dpcmVsZXNzIGZvbGRlcikgb3IKaXMgcHJlc2VudGVkIGluIGEgYmluYXJ5IGZvcm1hdC4gCgpJIG1lbnRpb24gdGhhdCBtb3N0IG9mIHRoZSBkcml2ZXJzIGZvciBsYXB0b3Bz4oCZIFdpRmkgY2hpcHNldHMgc2VlbXMgdG8gCmhhdmUgc3VwcG9ydCBmb3IgbXVsdGktdmlmcy4gV2hhdOKAmXMgdGhlIHJlYXNvbiAKZm9yIG5vdCBpbXBsZW1lbnRpbmcgdGhpcyBpbiB0aGUgZHJpdmVycyBmb3Igc21hcnRwaG9uZXPigJkgV2lGaSBjaGlwc2V0cz8KClNvcnJ5IGZvciB0aGUgd2FsbCBvZiB0ZXh0LiBUaGFua3MsCkRvcnUgCg==

