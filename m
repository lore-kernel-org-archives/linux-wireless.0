Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:55536 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3C1ITT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 04:19:19 -0400
Received: by mail-we0-f175.google.com with SMTP id t11so5793190wey.6
        for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 01:19:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <515392AF.8070809@lwfinger.net>
References: <CAGmUV-ugMOOv_OhG4+0CcQqJF1-nfRPUNwGtnzNRodXMOqS-bA@mail.gmail.com>
 <CAGmUV-vhBavw5=fM=Xt-bJVLp2zZSghrfOcWgHsYt_97_wy+4Q@mail.gmail.com>
 <CAGmUV-v9Bpn53JNYvmLpChtK_1Zj+ms0JGZC0=Tyc96SGfngLw@mail.gmail.com> <515392AF.8070809@lwfinger.net>
From: Ali Ustek <aliustek@gmail.com>
Date: Thu, 28 Mar 2013 08:18:37 +0000
Message-ID: <CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com> (sfid-20130328_091924_791174_80FBFDF4)
Subject: Re: Fwd: Ralink RT3290 card not supported
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	1156363@bugs.launchpad.net
Content-Type: multipart/mixed; boundary=f46d043c7c5893944e04d8f7cf58
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d043c7c5893944e04d8f7cf58
Content-Type: text/plain; charset=UTF-8

Sorry missed that, attached is the requested info

Thanks

On Thu, Mar 28, 2013 at 12:45 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 03/27/2013 06:13 PM, Ali Ustek wrote:
>>
>> Hi,
>>
>> The wi-fi chip Ralink RT3290 is common in notebooks but is not
>> supported by linux-kernel
>>
>> A bug is raised on Ubuntu launchpad
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1156363
>>
>> Some information about my system is attached
>>
>> Tested on 3.6, 3.8, 3.9rc3 and 3.9rc4
>>
>> Keywords: wifi, networking, kernel
>
>
> Nearly everything that you posted tells us nothing. One critical piece of
> information is given by "lspci -nn".
>
>
>

--f46d043c7c5893944e04d8f7cf58
Content-Type: application/octet-stream; name="lspci_nn.log"
Content-Disposition: attachment; filename="lspci_nn.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hetng1hh0

MDA6MDAuMCBIb3N0IGJyaWRnZSBbMDYwMF06IEludGVsIENvcnBvcmF0aW9uIDNyZCBHZW4gQ29y
ZSBwcm9jZXNzb3IgRFJBTSBDb250cm9sbGVyIFs4MDg2OjAxNTRdIChyZXYgMDkpCjAwOjAyLjAg
VkdBIGNvbXBhdGlibGUgY29udHJvbGxlciBbMDMwMF06IEludGVsIENvcnBvcmF0aW9uIDNyZCBH
ZW4gQ29yZSBwcm9jZXNzb3IgR3JhcGhpY3MgQ29udHJvbGxlciBbODA4NjowMTY2XSAocmV2IDA5
KQowMDoxNC4wIFVTQiBjb250cm9sbGVyIFswYzAzXTogSW50ZWwgQ29ycG9yYXRpb24gNyBTZXJp
ZXMvQzIxMCBTZXJpZXMgQ2hpcHNldCBGYW1pbHkgVVNCIHhIQ0kgSG9zdCBDb250cm9sbGVyIFs4
MDg2OjFlMzFdIChyZXYgMDQpCjAwOjE2LjAgQ29tbXVuaWNhdGlvbiBjb250cm9sbGVyIFswNzgw
XTogSW50ZWwgQ29ycG9yYXRpb24gNyBTZXJpZXMvQzIxMCBTZXJpZXMgQ2hpcHNldCBGYW1pbHkg
TUVJIENvbnRyb2xsZXIgIzEgWzgwODY6MWUzYV0gKHJldiAwNCkKMDA6MWEuMCBVU0IgY29udHJv
bGxlciBbMGMwM106IEludGVsIENvcnBvcmF0aW9uIDcgU2VyaWVzL0MyMTAgU2VyaWVzIENoaXBz
ZXQgRmFtaWx5IFVTQiBFbmhhbmNlZCBIb3N0IENvbnRyb2xsZXIgIzIgWzgwODY6MWUyZF0gKHJl
diAwNCkKMDA6MWIuMCBBdWRpbyBkZXZpY2UgWzA0MDNdOiBJbnRlbCBDb3Jwb3JhdGlvbiA3IFNl
cmllcy9DMjEwIFNlcmllcyBDaGlwc2V0IEZhbWlseSBIaWdoIERlZmluaXRpb24gQXVkaW8gQ29u
dHJvbGxlciBbODA4NjoxZTIwXSAocmV2IDA0KQowMDoxYy4wIFBDSSBicmlkZ2UgWzA2MDRdOiBJ
bnRlbCBDb3Jwb3JhdGlvbiA3IFNlcmllcy9DMjEwIFNlcmllcyBDaGlwc2V0IEZhbWlseSBQQ0kg
RXhwcmVzcyBSb290IFBvcnQgMSBbODA4NjoxZTEwXSAocmV2IGM0KQowMDoxYy4yIFBDSSBicmlk
Z2UgWzA2MDRdOiBJbnRlbCBDb3Jwb3JhdGlvbiA3IFNlcmllcy9DMjEwIFNlcmllcyBDaGlwc2V0
IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgMyBbODA4NjoxZTE0XSAocmV2IGM0KQowMDox
Yy4zIFBDSSBicmlkZ2UgWzA2MDRdOiBJbnRlbCBDb3Jwb3JhdGlvbiA3IFNlcmllcy9DMjEwIFNl
cmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgNCBbODA4NjoxZTE2XSAo
cmV2IGM0KQowMDoxYy41IFBDSSBicmlkZ2UgWzA2MDRdOiBJbnRlbCBDb3Jwb3JhdGlvbiA3IFNl
cmllcy9DMjEwIFNlcmllcyBDaGlwc2V0IEZhbWlseSBQQ0kgRXhwcmVzcyBSb290IFBvcnQgNiBb
ODA4NjoxZTFhXSAocmV2IGM0KQowMDoxZC4wIFVTQiBjb250cm9sbGVyIFswYzAzXTogSW50ZWwg
Q29ycG9yYXRpb24gNyBTZXJpZXMvQzIxMCBTZXJpZXMgQ2hpcHNldCBGYW1pbHkgVVNCIEVuaGFu
Y2VkIEhvc3QgQ29udHJvbGxlciAjMSBbODA4NjoxZTI2XSAocmV2IDA0KQowMDoxZi4wIElTQSBi
cmlkZ2UgWzA2MDFdOiBJbnRlbCBDb3Jwb3JhdGlvbiBITTc2IEV4cHJlc3MgQ2hpcHNldCBMUEMg
Q29udHJvbGxlciBbODA4NjoxZTU5XSAocmV2IDA0KQowMDoxZi4yIFNBVEEgY29udHJvbGxlciBb
MDEwNl06IEludGVsIENvcnBvcmF0aW9uIDcgU2VyaWVzIENoaXBzZXQgRmFtaWx5IDYtcG9ydCBT
QVRBIENvbnRyb2xsZXIgW0FIQ0kgbW9kZV0gWzgwODY6MWUwM10gKHJldiAwNCkKMDI6MDAuMCBT
eXN0ZW0gcGVyaXBoZXJhbCBbMDg4MF06IEpNaWNyb24gVGVjaG5vbG9neSBDb3JwLiBTRC9NTUMg
SG9zdCBDb250cm9sbGVyIFsxOTdiOjIzOTJdIChyZXYgMzApCjAyOjAwLjIgU0QgSG9zdCBjb250
cm9sbGVyIFswODA1XTogSk1pY3JvbiBUZWNobm9sb2d5IENvcnAuIFN0YW5kYXJkIFNEIEhvc3Qg
Q29udHJvbGxlciBbMTk3YjoyMzkxXSAocmV2IDMwKQowMjowMC4zIFN5c3RlbSBwZXJpcGhlcmFs
IFswODgwXTogSk1pY3JvbiBUZWNobm9sb2d5IENvcnAuIE1TIEhvc3QgQ29udHJvbGxlciBbMTk3
YjoyMzkzXSAocmV2IDMwKQowMzowMC4wIE5ldHdvcmsgY29udHJvbGxlciBbMDI4MF06IFJhbGlu
ayBjb3JwLiBSVDMyOTAgV2lyZWxlc3MgODAyLjExbiAxVC8xUiBQQ0llIFsxODE0OjMyOTBdCjAz
OjAwLjEgQmx1ZXRvb3RoIFswZDExXTogUmFsaW5rIGNvcnAuIFJUMzI5MCBCbHVldG9vdGggWzE4
MTQ6MzI5OF0KMDQ6MDAuMCBFdGhlcm5ldCBjb250cm9sbGVyIFswMjAwXTogUmVhbHRlayBTZW1p
Y29uZHVjdG9yIENvLiwgTHRkLiBSVEw4MTExLzgxNjggUENJIEV4cHJlc3MgR2lnYWJpdCBFdGhl
cm5ldCBjb250cm9sbGVyIFsxMGVjOjgxNjhdIChyZXYgMDcpCg==
--f46d043c7c5893944e04d8f7cf58--
