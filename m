Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48618 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbcEFLew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 07:34:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho\, Luciano" <luciano.coelho@intel.com>
Subject: Re: pull request: iwlwifi 2016-05-04
References: <1462385598.16756.9.camel@intel.com>
Date: Fri, 06 May 2016 14:34:45 +0300
In-Reply-To: <1462385598.16756.9.camel@intel.com> (Emmanuel Grumbach's message
	of "Wed, 4 May 2016 18:13:18 +0000")
Message-ID: <87twibs9m2.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_133455_741091_8B63ACEF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> I know it is extremely late in the cycle, but this patch is intended
> for 4.6... It fixes a regression I introduced: a P2P specification
> violation as mentioned in the commit message.
> The patch is rather big in terms of number of lines changed, but the
> semantics is very simple. I have to copy the control block of the skb
> to the stack whereas we accessed we used to access it directly through
> a pointer.
> This obviously introduces a lot of line changes, but don't really
> change the behavior of the code (since most of the accesses are read
> only).
>
> Let me know how it goes.

[...]

> The following changes since commit f742aaf36edf0390c54d0614bc4d20fd4cd3762a:
>
>   iwlwifi: mvm: fix accessing Null pointer during fw dump collection (2016-04-12 11:52:39 +0300)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2016-05-04

Pulled, thanks. Let's see if this makes it to 4.6.

> I take this opportunity to inform you that I will be replaced by Luca
> for a few months at least. I will be working full steam on a side
> project that will not allow me to do the maintainer job in parallel.

Ok, have fun in your new project.

Luca, as we _finally_ got sun here in Finland we have to have a "kick
off meeting about the new organisation structure" by your grill ;)

-- 
Kalle Valo
