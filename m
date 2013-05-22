Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48657 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab3EVTm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 15:42:27 -0400
Received: by mail-wi0-f173.google.com with SMTP id hi5so4068443wib.12
        for <linux-wireless@vger.kernel.org>; Wed, 22 May 2013 12:42:26 -0700 (PDT)
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl> <20130522190145.GJ2113@tuxdriver.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130522190145.GJ2113@tuxdriver.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <54CB38BA-6701-4249-ADFA-761B3C95C084@gmail.com> (sfid-20130522_214234_626768_0FD6AC51)
Cc: "stf_xl@wp.pl" <stf_xl@wp.pl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 00/32] BBP initialization split
Date: Wed, 22 May 2013 21:42:23 +0200
To: "John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Sent from my iPad

On 22 mei 2013, at 21:01, "John W. Linville" <linville@tuxdriver.com> wrote:

> On Sat, May 18, 2013 at 02:03:23PM +0200, stf_xl@wp.pl wrote:
>> This series spits big and messy rt2800_init_bbp() procedure into small
>> per chip (or few similar chips) subroutines.
> 
> Lots of refactoring here -- I trust Stanislaw, but it might be nice
> to see an ACK from Gertjan, Helmut, and/or Ivo?

I believe Helmut already acked it, but I don't have issues with the patch set. So, you can add my

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

to the whole series.

---
Gertjan
