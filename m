Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:14858 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbXKNS5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 13:57:54 -0500
Received: by py-out-1112.google.com with SMTP id u77so2943060pyb
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 10:57:52 -0800 (PST)
Message-ID: <8e6f94720711141057w463d55c4r2be74d0aa8d78918@mail.gmail.com> (sfid-20071114_185759_193799_3BD1F401)
Date: Wed, 14 Nov 2007 13:57:52 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Florian Lohoff" <flo@rfc822.org>
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Cc: "Marcus Better" <marcus@better.se>, linux-wireless@vger.kernel.org
In-Reply-To: <20071114153347.GA3512@paradigm.rfc822.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071111102315.GC10486@paradigm.rfc822.org>
	 <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com>
	 <20071113192330.GA19601@paradigm.rfc822.org>
	 <fhedc4$5l9$1@ger.gmane.org>
	 <20071114153347.GA3512@paradigm.rfc822.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 14, 2007 10:33 AM, Florian Lohoff <flo@rfc822.org> wrote:

> Did you actually try setting the rate manually? I just tried
> when i came home from work. I set it to 36MBit/s and it actually
> works ... I am now transferring with 2.5MByte/s instead of 30Kbyte/s
>
> So i guess the auto rate selection is broken ... Or 1 MBit/s is default
> or something ...

Ah, that is probably this isssue:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=d37cabfb5f60a3bb56585a74fd3f140ba2960fe0

The patch is in the wireless-2.6/everything tree, but not Linus's tree.

-- 
Will Dyson
