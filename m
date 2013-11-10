Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:38182 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3KJMNk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 07:13:40 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DEDB31@HASMSX103.ger.corp.intel.com>
References: <5276134B.8070808@wzyboy.org> <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
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
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CAErSpo6ry6cUaVngozS8-P44=LPJN6cbsZ_mfWkJv9Rn85YXUQ@mail.gmail.com>
 <CALkVjQZEs1CqMEVApDDGZ6FDugPZ+-F5wzvE45+jB5Xrhv_N2A@mail.gmail.com>
 <CANUX_P33UqkCsfHrJW+gx-ZbEQduJ1EZ59fpx6T6wQWOLufSqg@mail.gmail.com>
 <CALkVjQYNPXpTjUpR9NZU6MTJhUmYeO1jXWvOOxk8-Pm=xdKZLg@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DEDB31@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Sun, 10 Nov 2013 20:13:22 +0800
Message-ID: <CALkVjQbkZSvhbEAwEK-LQGjKX6kdvAMB1UUuFuW3GGO60r0wKQ@mail.gmail.com> (sfid-20131110_131345_370756_FC6ADF40)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8ff1c3508de1eb04ead18b97
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--e89a8ff1c3508de1eb04ead18b97
Content-Type: text/plain; charset=UTF-8

2013/11/10 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> It is really called L1 PM Substate.
> I don't really know the BIOS of ThinkPad... But we can try...


I have booted into BIOS and write down almost all the options, as attached.

By the way, I always attach my laptop to an AC adaptor.


-- 
wzyboy

--e89a8ff1c3508de1eb04ead18b97
Content-Type: text/plain; charset=US-ASCII; name="x240s-bios.txt"
Content-Disposition: attachment; filename="x240s-bios.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnu8s7f10

W01haW5dCglVRUZJIEJJT1MgVmVyc2lvbjogR0lFVDYyV1cgKDIuMTIpCglVRUZJIEJJT1MgRGF0
ZTogMjAxMy0wOS0yNQoJRW1iZWRkZWQgQ29udHJvbGxlciBWZXJzaW9uOiBHSUhUMjNXVyAoMS4w
MCkKCU1FIEZpcm13YXJlIFZlcnNpb246IDkuNS4zLjE1MjAKCU1hY2hpbmUgVHlwZSBNb2RlbDog
MjBBS0NUTzFXVwoJU3lzdGVtLXVuaXQgc2VyaWFsIG51bWJlcjogUEYgMDAwTjNWCglTeXN0ZW0g
Ym9hcmQgc2VyaWFsIG51bWJlcjogMTJTUlQzN0QxMTIKCUFzc2V0IFRhZzogTm8gQXNzZXQgSW5m
b3JtYXRpb24KCUNQVSBUeXBlOiBJbnRlbChSKSBDb3JlKFRNKSBpNy00NTAwVSBDUFUKCUNQVSBT
cGVlZDogMS44MEdIegoJSW5zdGFsbGVkIG1lbW9yeTogODE5Mk1CCglVVUlEOiBbLi4uXQoJTUFD
IEFkZHJlc3MgKEludGVybmFsIExBTik6IDI4IEQyIDQ0IDFBIEJEIDI2CglVRUZJIFNlY3VyZSBC
b290OiBPZmYKW0NvbmZpZ10KCU5ldHdvcmsKCQlXYWtlIG9uIExBTiBbRGlzYWJsZWRdCgkJRXRo
ZXJuZXQgTEFOIE9wdGlvbiBST00gW0Rpc2FibGVkXQoJVVNCCgkJVVNCIFVFRkkgQklPUyBTdXBw
b3J0IFtFbmFibGVkXQoJCUFsd2F5cyBvbiBVU0IgW0VuYWJsZWRdCgkJLSBDaGFyZ2UgaW4gQmF0
dGVyeSBNb2RlIFtFbmFibGVkXQoJCVVTQiAzLjAgTW9kZSBbQXV0b10KCUtleWJvYXJkL01vdXNl
CgkJVHJhY2tQb2ludCBbRW5hYmxlZF0KCQlUcmFja3BhZCBbRW5hYmxlZF0KCQlGbiBhbmQgQ3Ry
bCBLZXkgc3dhcCBbRW5hYmxlZF0KCURpc3BsYXkKCQlCb290IERpc3BsYXkgRGV2aWNlIFtUaGlu
a1BhZCBMQ0RdCglQb3dlcgoJCUludGVsIChSKSBTcGVlZFN0ZXAgdGVjaG5vbG9neSBbRW5hYmxl
ZF0KCQktIE1vZGUgZm9yIEFDIFtNYXhpbXVtIFBlcmZvcm1hbmNlXQoJCS0gTW9kZSBmb3IgQmF0
dGVyeSBbQmF0dGVyeSBPcHRpbWl6ZWRdCgkJQWRhcHRpdmUgVGhlcm1hbCBNYW5hZ2VtZW50CgkJ
LSBTY2hlbWUgZm9yIEFDIFtNYXhtaXplIFBlcmZvcm1hbmNlXQoJCS0gU2NoZW1lIGZvciBCYXR0
ZXJ5IFtCYWxhbmNlZF0KCQlDUFUgUG93ZXIgTWFuYWdlbWVudCBbRW5hYmxlZF0KCQlQb3dlciBP
biB3aXRoIEFDIEF0dGFjaCBbRGlzYWJsZWRdCgkJSW50ZWwgKFIpIFJhcGlkIFN0YXJ0IFRlY2hu
b2xvZ3kgW0Rpc2FibGVkXQoJCURpc2FibGUgQnVpbGQtaW4gQmF0dGVyeSBbRW50ZXJdCglCZWVw
IGFuZCBBbGFybQoJCVBhc3N3b3JkIEJlZXAgW0Rpc2FibGVkXQoJCUtleWJvYXJkIEJlZXAgW0Rp
c2FibGVkXQpbRGF0ZS9UaW1lXQoJU3lzdGVtIERhdGUKCVN5c3RlbSBUaW1lCltTZWN1cml0eV0K
CVBhc3N3b3JkCgkJWy4uLl0KCUZpbmdlcnByaW50CgkJWy4uLl0KCVNlY3VyaXR5IENoaXAKCQlb
Li4uXQoJVUVGSSBCSU9TIFVwZGF0ZSBPcHRpb24KCQlbLi4uXQoJTWVtb3J5IFByb3RlY3Rpb24K
CQlFeGVjdXRpb24gUHJldmVudGlvbiBbRGlzYWJsZWRdCglWaXJ0dWFsaXphdGlvbgoJCUludGVs
IChSKSBWaXJ0dWFsaXphdGlvbiBUZWNobm9sb2d5IFtFbmFibGVkXQoJSS9PIFBvcnQgQWNjZXNz
CgkJRXRoZXJuZXQgTEFOIFtFbmFibGVkXQoJCVdpcmVsZXNzIExBTiBbRW5hYmxlZF0KCQlXaXJl
bGVzcyBXQU4gW0VuYWJsZWRdCgkJQmx1ZXRvb3RoIFtFbmFibGVkXQoJCVVTQiBQb3J0IFtFbmFi
bGVkXQoJCU1lbW9yeSBDYXJkIFNsb3QgW0VuYWJsZWRdCgkJSW50ZWdyYXRlZCBDYW1lcmEgW0Vu
YWJsZWRdCgkJTWljcm9waG9uZSBbRW5hYmxlZF0KCQlGaW5nZXJwcmludCBSZWFkZXIgW0VuYWJs
ZWRdCglJbnRlcm5hbCBEZXZpY2UgQWNjZXNzCgkJQm90dG9tIENvdmVyIFRhbXBlciBEZXRlY3Rp
b24gW0Rpc2FibGVkXQoJQW50aS1UaGVmdAoJCVsuLi5dCglTZWN1cmUgQm9vdAoJCVsuLi5dCltT
dGFydHVwXQoJQm9vdAoJTmV0d29yayBCb290IFtQQ0kgTEFOXQoJVUVGSS9MZWdhY3kgQm9vdCBb
TGVnYWN5IE9ubHldCgktIENTTSBTdXBwb3J0IFtZZXNdCglCb290IE1vZGUgW1F1aWNrXQoJT3B0
aW9uIGtleSBEaXNwbGF5IFtFbmFibGVkXQoJQm9vdCBkZXZpY2UgTGlzdCBGMTIgT3B0aW9uIFtF
bmFibGVkXQoJQm9vdCBPcmRlciBMb2NrIFtEaXNhYmxlZF0KW1Jlc3RhcnRdCgkuLi4K
--e89a8ff1c3508de1eb04ead18b97--
