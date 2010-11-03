Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40788 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0KCRrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 13:47:45 -0400
Received: by qyk10 with SMTP id 10so319948qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 10:47:45 -0700 (PDT)
From: Ben Gamari <bgamari@gmail.com>
To: =?utf-8?Q?Bj=C3=B6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
In-Reply-To: <AANLkTik+dFEAqGdk9NJpbr8tGKc_NagO8nXSBF4sDtTt@mail.gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com> <8762whrqvm.fsf@gmail.com> <AANLkTik+dFEAqGdk9NJpbr8tGKc_NagO8nXSBF4sDtTt@mail.gmail.com>
Date: Wed, 03 Nov 2010 13:47:34 -0400
Message-ID: <87k4kuuwnd.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2 Nov 2010 17:55:22 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
> Ben, if you can easily trigger these problems on wireless-testing,
> could you test with my patch and see if it helps? I'm especially
> interested to see if it really fixes problem 1.
> 
The only time I've been able to reproduce the issue with
wireless-testing is when using my work laptop. I'll bring it home
tonight and see if your patch makes any difference. Thanks,

- Ben

