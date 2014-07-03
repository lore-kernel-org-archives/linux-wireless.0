Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45114 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaGCMuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 08:50:22 -0400
Received: by mail-ob0-f177.google.com with SMTP id uy5so191625obc.22
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 05:50:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rxVjnpMgQx9+d_LbROYNnnjnuMEGo-38MPwjsPtxYdN8w@mail.gmail.com>
References: <CACna6rxVjnpMgQx9+d_LbROYNnnjnuMEGo-38MPwjsPtxYdN8w@mail.gmail.com>
Date: Thu, 3 Jul 2014 14:50:21 +0200
Message-ID: <CACna6rx+EkoCPQ06qDTbaDFEJ1hrn_CYSbrPmosF0ikhkqDxpA@mail.gmail.com> (sfid-20140703_145032_004211_FF41605C)
Subject: Re: Looking for someone with BCM43227 and (maybe) compilation skill ;)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b414164af6f7704fd49738f
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--047d7b414164af6f7704fd49738f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 3 July 2014 14:32, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> I want to add support for BCM43227 in b43, however I need help of some
> BCM43227 owner. Well, I could buy one by myself (less than 10$ on
> eBay), but I don't want to wait a month to receive it.
>
> So I need someone with:
> 1) BCM43227 ;)
> 2) Kernel with CONFIG_MMIOTRACE=3Dy*
> 3) Broadcom Linux STA driver 6.30.223.141
>
> So? Is there anyone around with BCM43227 willing to help?

I'd need someone to:
1) Disable NetworkManager & blacklist wl
2) Make a cold boot (power off for 3 seconds)
3) Run attached script
4) Provide me /tmp/dump.txt (preferably compressed)

--047d7b414164af6f7704fd49738f
Content-Type: application/x-sh; name="mmiotrace.sh"
Content-Disposition: attachment; filename="mmiotrace.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hx62jk361

IyEvYmluL3NoCgplY2hvIDQwOTQgPiAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2J1ZmZlcl9z
aXplX2tiCmVjaG8gbW1pb3RyYWNlID4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9jdXJyZW50
X3RyYWNlcgpjYXQgL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy90cmFjZV9waXBlID4gL3RtcC9k
dW1wLnR4dCAmCgpzbGVlcCAycwoKZWNobyAibW9kcHJvYmUgc3RhcnQiID4gL3N5cy9rZXJuZWwv
ZGVidWcvdHJhY2luZy90cmFjZV9tYXJrZXIKbW9kcHJvYmUgd2wKZWNobyAibW9kcHJvYmUgZW5k
IiA+IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvdHJhY2VfbWFya2VyCgpzbGVlcCAycwoKZWNo
byAiaXAgbGluayBzZXQgd2xhblggdXAgc3RhcnQiID4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2lu
Zy90cmFjZV9tYXJrZXIKaXAgbGluayBzZXQgd2xhbjAgdXAKZWNobyAiaXAgbGluayBzZXQgd2xh
blggdXAgZW5kIiA+IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvdHJhY2VfbWFya2VyCgpzbGVl
cCAycwoKZWNobyAiaXcgZGV2IHdsYW5YIHNjYW4gc3RhcnQiID4gL3N5cy9rZXJuZWwvZGVidWcv
dHJhY2luZy90cmFjZV9tYXJrZXIKaXcgZGV2IHdsYW4wIHNjYW4KZWNobyAiaXcgZGV2IHdsYW5Y
IHNjYW4gZW5kIiA+IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvdHJhY2VfbWFya2VyCgplY2hv
IG5vcCA+IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvY3VycmVudF90cmFjZXIKa2lsbGFsbCBj
YXQK
--047d7b414164af6f7704fd49738f--
