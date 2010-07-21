Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57819 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0GUFq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 01:46:26 -0400
Received: by qyk38 with SMTP id 38so2945788qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 22:46:25 -0700 (PDT)
From: Ben Gamari <bgamari@gmail.com>
To: Bruno Randolf <br1@einfach.org>, Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
In-Reply-To: <201007211417.23512.br1@einfach.org>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <201007211004.59372.br1@einfach.org> <20100721034150.GA16632@hash.localnet> <201007211417.23512.br1@einfach.org>
Date: Wed, 21 Jul 2010 01:46:22 -0400
Message-ID: <87d3uhidzl.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Jul 2010 14:17:23 +0900, Bruno Randolf <br1@einfach.org> wrote:
> but that's for all tracepoints all over the kernel... i think it's natural 
> that this takes some CPU time. note that on these boards even the 22Mbps are 
> limited by the CPU processing power.
> 
The key word here is some. The numbers that you pointed out suggest that
the effect here is quite large. I find it hard to believe that something
isn't going wrong here. A single branch instruction really shouldn't be
this onerous unless it's in a fast path, in which case it should
probably be a compile-time option. What is the difference in image size
between kernels with and without tracing?

- Ben
