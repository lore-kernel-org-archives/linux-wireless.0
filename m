Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:8530 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYLLTtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 14:49:14 -0500
Received: by yw-out-2324.google.com with SMTP id 9so752607ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 11:49:13 -0800 (PST)
Message-ID: <b6c5339f0812121149h10a684b6v5b9815148da9541@mail.gmail.com> (sfid-20081212_204921_009671_C9602DA0)
Date: Fri, 12 Dec 2008 14:49:13 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ath5k-devel] Bugs in ath5k on aspire one (AR2425)
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <1229110842.14247.27.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <492712D9.7080004@gmail.com>
	 <1229110842.14247.27.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 2:40 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> It sometimes happen on resume from ram.
>
> It is NOT noise calibration, but a gain calibration timeout
> Only fix is to reboot the system, as module reload doesn't help.

I really think it is various sides of the same coin with multiple
manifestations.  There are bugzilla bugs now:

http://bugzilla.kernel.org/show_bug.cgi?id=12080
http://bugzilla.kernel.org/show_bug.cgi?id=12068

-- 
Bob Copeland %% www.bobcopeland.com
