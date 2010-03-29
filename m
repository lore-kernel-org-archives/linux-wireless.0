Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53172 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0C2XjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <1269905624.4558.56.camel@Joe-Laptop.home>
References: <1269904339-15599-1-git-send-email-luisbg@ubuntu.com>
	 <1269905624.4558.56.camel@Joe-Laptop.home>
Date: Tue, 30 Mar 2010 00:39:18 +0100
Message-ID: <506b70dc1003291639j4a620ef0ve551d97bea26fa2e@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath: fix macros coding style issue in regd.c
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 12:33 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2010-03-30 at 00:12 +0100, Luis de Bethencourt wrote:
>> This is a patch to the ath/regd.c file that fixes up three warnings
>> about macros found by the checkpatch.pl tool, these said that
>> complex values should be enclosed in parenthesis.
>
> Hi Luis.
>
> Checkpatch isn't always correct.
>
> Please make sure to compile test your changes
> before submitting them.
>
> These macros are used as initializers and
> can not be surrounded by parentheses.
>
>        .reg_rules = {
>                ATH9K_2GHZ_ALL,
>
> cheers, Joe
>
>

Hi Joe,

Sorry about this. I compiled test the changes but make didn't complain.

My bad, will try to avoid this better in the future.

Luis
