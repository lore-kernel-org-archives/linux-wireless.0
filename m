Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:54940 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZESRPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 13:15:19 -0400
Received: by bwz22 with SMTP id 22so3962862bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 10:15:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45e8e6c40905181614i20c330b8sc982b0acc565708a@mail.gmail.com>
References: <E1M5voF-0003wt-00.counter-strike-bk-ru@f144.mail.ru>
	<45e8e6c40905181614i20c330b8sc982b0acc565708a@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 19 May 2009 19:14:59 +0200
Message-ID: <69e28c910905191014o5ac0f99ard03f3750ec6a4f0c@mail.gmail.com>
Subject: Re:
To: Andrey Yurovsky <yurovsky@gmail.com>
Cc: Wladimir Hirnij <counter-strike@bk.ru>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Decoded version:

The rtl8187se is not supported by the mainline driver.  There's a
driver for it in staging though, and there's a vendor driver hosted
here:
http://code.google.com/p/msi-wind-linux/
...I would try to build and load that driver for now.

  -Andrey

2009/5/19 Andrey Yurovsky <yurovsky@gmail.com>:
> MjAwOS81LzE3IFdsYWRpbWlyIEhpcm5paiA8Y291bnRlci1zdHJpa2VAYmsucnU+Ogo+IPrE0sHX
> 09TX1crUxS4KPiD0wcvB0SDQ0s/CzMXNwSBzbGFja3dhcmUgMTIuMiCa0cTSzyAyLjYuMjcgzsUg
> zc/H1SDV09TBzs/XydTYIMTSwcrXxdLBIM7BIHdpZmkgcnRsODE4N3NlLgo+IO/exc7YINDSz9vV
> INDPzc/e2CDF08zJINzUzyDXz9rNz9bOzy4KPiDl08zJINzUzyDXz9rNz9bOzyDUzyDQz9bBzNXK
> 09TBINDPxNLPws7PIM/QydvJ1MUgy8HLINzUzyDExczB1Ngg09nMy8HNySDOwSDE0sHK18XSwSDJ
> IMTP0M/MzsnU0sXM2M7ZxSDQwcvF1NkgKMkgy8HLIMnIINXT1MHOz9fJ1NgpLgo+IGFwdC1nZXQg
> zsXU1SgKPiDT1M/J1CBzbGFwdC1nZXQgzsXazsHAIMvByyDJzSDQz8zY2s/XwdTY09EuCj4g+sHS
> wc7FxSDT0MHTycLPLgoKVGhlIHJ0bDgxODdzZSBpcyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSBtYWlu
> bGluZSBkcml2ZXIuICBUaGVyZSdzIGEKZHJpdmVyIGZvciBpdCBpbiBzdGFnaW5nIHRob3VnaCwg
> YW5kIHRoZXJlJ3MgYSB2ZW5kb3IgZHJpdmVyIGhvc3RlZApoZXJlOgpodHRwOi8vY29kZS5nb29n
> bGUuY29tL3AvbXNpLXdpbmQtbGludXgvCi4uLkkgd291bGQgdHJ5IHRvIGJ1aWxkIGFuZCBsb2Fk
> IHRoYXQgZHJpdmVyIGZvciBub3cuCgogIC1BbmRyZXkK
-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
