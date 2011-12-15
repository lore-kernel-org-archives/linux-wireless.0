Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39907 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1LOKZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 05:25:50 -0500
Received: by vbbfc26 with SMTP id fc26so1376986vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 02:25:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2fSehL_3ntoQDN0qzfSycx_hLP7R2Nn2V+iaubc5RX4A@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
	<CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com>
	<CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
	<CAD2nsn0Zqw0zdEUrMCnBKKLsZEBw_qqT5MO=7dHCwj8Hd6WpqQ@mail.gmail.com>
	<CAD2nsn2fSehL_3ntoQDN0qzfSycx_hLP7R2Nn2V+iaubc5RX4A@mail.gmail.com>
Date: Thu, 15 Dec 2011 15:55:49 +0530
Message-ID: <CAD2nsn0-OgCvHtx+xHeDtHEJK7s1svxt5jzLmkZNn-huaN3y5g@mail.gmail.com> (sfid-20111215_112553_585188_6EA9114C)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: multipart/mixed; boundary=bcaec51b9db1811aa604b41ee884
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--bcaec51b9db1811aa604b41ee884
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 15, 2011 at 2:36 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Thu, Dec 15, 2011 at 1:24 PM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
>> On Thu, Dec 15, 2011 at 12:55 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
>>> I tried the bleeding edge build of compat-wireless
>>> (compat-wireless-2011-12-14 build) on Linux-3.1.5. It still leads to kernel
>>> panic. I manually got the AP up with these steps:

hi Ashwin,

can you please try the attached patch and it seems to work for me.
please go to your compat directory
cd compat...
then do patch -p1 < ./fix-ar2427-ap-mode-panic.patch

-- 
shafi

--bcaec51b9db1811aa604b41ee884
Content-Type: text/x-diff; charset=US-ASCII; name="fix-ar2427-ap-mode-panic.patch"
Content-Disposition: attachment; filename="fix-ar2427-ap-mode-panic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gw7mh64o0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jCmluZGV4IDdkOTIwMDQuLjVhZmMwOWMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21haW4uYwpAQCAtMTgwNCw2ICsxODA0LDkg
QEAgc3RhdGljIHZvaWQgYXRoOWtfc3RhX25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IAlzdHJ1Y3QgYXRoX3NvZnRjICpzYyA9IGh3LT5wcml2OwogCXN0cnVjdCBhdGhfbm9kZSAqYW4g
PSAoc3RydWN0IGF0aF9ub2RlICopIHN0YS0+ZHJ2X3ByaXY7CiAKKwlpZiAoIShzYy0+c2NfZmxh
Z3MgJiBTQ19PUF9UWEFHR1IpKQorCQlyZXR1cm47CisKIAlzd2l0Y2ggKGNtZCkgewogCWNhc2Ug
U1RBX05PVElGWV9TTEVFUDoKIAkJYW4tPnNsZWVwaW5nID0gdHJ1ZTsK
--bcaec51b9db1811aa604b41ee884--
