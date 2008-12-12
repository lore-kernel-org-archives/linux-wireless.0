Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:14601 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYLLT51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 14:57:27 -0500
Received: by mu-out-0910.google.com with SMTP id g7so936533muf.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 11:57:25 -0800 (PST)
Subject: Re: [ath5k-devel] Bugs in ath5k on aspire one (AR2425)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0812121149h10a684b6v5b9815148da9541@mail.gmail.com>
References: <492712D9.7080004@gmail.com>
	 <1229110842.14247.27.camel@maxim-laptop>
	 <b6c5339f0812121149h10a684b6v5b9815148da9541@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 21:57:20 +0200
Message-Id: <1229111840.14247.30.camel@maxim-laptop> (sfid-20081212_205730_425400_49FF51D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-12-12 at 14:49 -0500, Bob Copeland wrote:
> On Fri, Dec 12, 2008 at 2:40 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > It sometimes happen on resume from ram.
> >
> > It is NOT noise calibration, but a gain calibration timeout
> > Only fix is to reboot the system, as module reload doesn't help.
> 
> I really think it is various sides of the same coin with multiple
> manifestations.  There are bugzilla bugs now:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12080
> http://bugzilla.kernel.org/show_bug.cgi?id=12068
> 


Thanks, 

I will install latest wireless-testing, enable debug, and try to catch
this, here it seems to happen after suspend to ram.
(Sometimes, about 1 in 20 times, maybe more)

Best regards,
	Maxim Levitsky

