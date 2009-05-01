Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:37423 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZEAMHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 08:07:06 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1349345ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 05:07:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241036667.12942.0.camel@maxim-laptop>
References: <1240761579.10972.11.camel@maxim-laptop>
	 <1241036667.12942.0.camel@maxim-laptop>
Date: Fri, 1 May 2009 08:07:06 -0400
Message-ID: <b6c5339f0905010507x75b14181t7263eb1717cd278e@mail.gmail.com>
Subject: Re: PHY hangs on AR2425 (AR5007EG)
From: Bob Copeland <bcopeland@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 29, 2009 at 4:24 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> The issue is that if I load its TX unit up to it's maximum throughput,
>> it stalls each and every few seconds, and only way to
>
> Are you aware of that bug?

Yeah, thanks, haven't lost the report but haven't
had a chance to investigate so far.

By load TX up, do you mean you are sending large
files, using ping, iperf, or.. ?

-- 
Bob Copeland %% www.bobcopeland.com
