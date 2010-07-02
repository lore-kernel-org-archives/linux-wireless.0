Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:49442 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0GBSYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:24:46 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Fri, 02 Jul 2010 20:27:20 +0200
MIME-Version: 1.0
Content-type: Multipart/Mixed; boundary=Message-Boundary-3360
Subject: Re: Enabling channels 12,13
CC: Paul Fertser <fercerpav@gmail.com>
Message-ID: <4C2E2F88.1417.7EBB5@jafojtik.seznam.cz>
In-reply-to: <20100702173625.GD974@home.pavel.comp>
References: <20100702173625.GD974@home.pavel.comp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Message-Boundary-3360
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body

Dear Paul Fertser,

thank you for a hint.

But unfortunatelly this patch (attached) does not work for me.
May be for multiple devices? Who knows.

Band 1:
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)



[    4.464183] ath5k 0000:02:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.464328] ath5k 0000:02:08.0: registered as 'phy0'
[    5.059773] ath5k phy0: DANGER! You're overriding EEPROM-defined regulatory domain.
[    5.059837] ath5k phy0: Your card was not certified to operate on the domain you choosed.
[    5.059902] ath5k phy0: This might result in a violation of your local regulatory rules.
--
[    5.122197] ath5k 0000:02:0a.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.122338] ath5k 0000:02:0a.0: registered as 'phy1'
[    5.587528] ath5k phy1: DANGER! You're overriding EEPROM-defined regulatory domain.
[    5.587593] ath5k phy1: Your card was not certified to operate on the domain you choosed.
[    5.588358] ath5k phy1: This might result in a violation of your local regulatory rules.

> Please see this for reference:
> http://forum.aircrack-ng.org/index.php?topic=6822.15
> 
> You can also try "pentoo" gentoo overlay.

regards
   Jara


> 
> HTH
> -- 
> Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
> mailto:fercerpav@gmail.com



--Message-Boundary-3360
Content-type: Application/Octet-stream; name="ath5k_regdomain_override.patch"; type=Unknown
Content-disposition: attachment; filename="ath5k_regdomain_override.patch"
Content-transfer-encoding: BASE64

UGF1bEZlcnRzZXI+IEdldCBfeW91cl8gY291bnRyeSBjb2RlIGZyb20gcmVnZC5oLCBhZGQg
MzI3NjggYW5kIHN1cHBseSBhcyBhIHBhcmFtZXRlci4NCmZlcmNlcnBhdkBnbWFpbC5jb20N
Ci0tLSBsaW51eC0yLjYuMzItZ2VudG9vLXIxLW9yaWcvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YXRoL2F0aDVrL2Jhc2UuYwkyMDA5LTEyLTAzIDA2OjUxOjIxLjAwMDAwMDAwMCArMDMwMA0K
KysrIGxpbnV4LTIuNi4zMi1nZW50b28tcjEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0
aDVrL2Jhc2UuYwkyMDEwLTAxLTE2IDAwOjAyOjUxLjAwMDAwMDAwMCArMDMwMA0KQEAgLTY4
LDYgKzY4LDExIEBADQogbW9kdWxlX3BhcmFtX25hbWVkKGFsbF9jaGFubmVscywgbW9kcGFy
YW1fYWxsX2NoYW5uZWxzLCBib29sLCBTX0lSVUdPKTsNCiBNT0RVTEVfUEFSTV9ERVNDKGFs
bF9jaGFubmVscywgIkV4cG9zZSBhbGwgY2hhbm5lbHMgdGhlIGRldmljZSBjYW4gdXNlLiIp
Ow0KIA0KK3N0YXRpYyBpbnQgbW9kcGFyYW1fb3ZlcnJpZGVfZWVwcm9tX3JlZ2RvbWFpbiA9
IC0xOw0KK21vZHVsZV9wYXJhbV9uYW1lZChvdmVycmlkZV9lZXByb21fcmVnZG9tYWluLCAN
CisJCQltb2RwYXJhbV9vdmVycmlkZV9lZXByb21fcmVnZG9tYWluLCBpbnQsIFNfSVJVR08p
Ow0KK01PRFVMRV9QQVJNX0RFU0Mob3ZlcnJpZGVfZWVwcm9tX3JlZ2RvbWFpbiwgIk92ZXJy
aWRlIHJlZ2RvbWFpbiBoYXJkY29kZWQgaW4gRUVQUk9NIHdpdGggdGhpcyB2YWx1ZSAoREFO
R0VST1VTKS4iKTsNCisNCiANCiAvKioqKioqKioqKioqKioqKioqXA0KICogSW50ZXJuYWwg
ZGVmaW5lcyAqDQpAQCAtNTcyLDYgKzU3NywxNSBAQA0KIAkJZ290byBlcnJfaXJxOw0KIAl9
DQogDQorCWlmIChtb2RwYXJhbV9vdmVycmlkZV9lZXByb21fcmVnZG9tYWluICE9IC0xKSB7
DQorCQlBVEg1S19FUlIoc2MsICJEQU5HRVIhIFlvdSdyZSBvdmVycmlkaW5nIEVFUFJPTS1k
ZWZpbmVkIHJlZ3VsYXRvcnkgZG9tYWluLlxuIik7DQorCQlBVEg1S19FUlIoc2MsICJZb3Vy
IGNhcmQgd2FzIG5vdCBjZXJ0aWZpZWQgdG8gb3BlcmF0ZSBvbiB0aGUgZG9tYWluIHlvdSBj
aG9vc2VkLlxuIik7DQorCQlBVEg1S19FUlIoc2MsICJUaGlzIG1pZ2h0IHJlc3VsdCBpbiBh
IHZpb2xhdGlvbiBvZiB5b3VyIGxvY2FsIHJlZ3VsYXRvcnkgcnVsZXMuXG4iKTsNCisJCUFU
SDVLX0VSUihzYywgIkRvIG5vdCBldmVyIGRvIHRoYXQgdW5sZXNzIHlvdSByZWFsbHkga25v
dyB3aGF0IHlvdSBkbyFcbiIpOw0KKwkJc2MtPmFoLT5haF9jYXBhYmlsaXRpZXMuY2FwX2Vl
cHJvbS5lZV9yZWdkb21haW4gPQ0KKwkJCW1vZHBhcmFtX292ZXJyaWRlX2VlcHJvbV9yZWdk
b21haW47DQorCX0NCisNCiAJLyogc2V0IHVwIG11bHRpLXJhdGUgcmV0cnkgY2FwYWJpbGl0
aWVzICovDQogCWlmIChzYy0+YWgtPmFoX3ZlcnNpb24gPT0gQVI1S19BUjUyMTIpIHsNCiAJ
CWh3LT5tYXhfcmF0ZXMgPSA0Ow0KDQo=

--Message-Boundary-3360--
