Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34879 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0DBFCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 01:02:10 -0400
Received: by pva18 with SMTP id 18so783180pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 22:02:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
References: <m2p43e72e891004012145s2f344f7fo9b12044e9b895c06@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 1 Apr 2010 22:01:49 -0700
Message-ID: <t2t43e72e891004012201xc3e1d823sb20e2b1d9a5460cd@mail.gmail.com>
Subject: Re: iwlagn unexpected AddBA Req
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 1, 2010 at 9:45 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> [  117.491303] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
> [  178.467383] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
> [  239.447236] unexpected AddBA Req from 00:22:6b:56:fd:e9 on tid 0
>
> I get a lof of these at spurious times against my WRT610N using
> today's wireless-testing on iwlagn.

Here's a very simply way to reproduce this -- I ping my AP and keep
only that connection alive. I see this come up every minute. I see the
MCS rate fluctuate between 7 and 15 @ HT40 Short GI, and also 6
Mbit/s. This is on 5 GHz.

  Luis
