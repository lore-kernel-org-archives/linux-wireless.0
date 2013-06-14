Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61775 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FNVit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 17:38:49 -0400
Received: by mail-wg0-f54.google.com with SMTP id n11so937341wgh.9
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 14:38:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370953555.8356.33.camel@jlt4.sipsolutions.net>
References: <1370280816-9799-1-git-send-email-ashok@cozybit.com> <1370953555.8356.33.camel@jlt4.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Fri, 14 Jun 2013 14:38:27 -0700
Message-ID: <CACcxo+r1O7DdJ3Ys70=Z1JLVuHFHvfj0eBTfRMfqAihC=ssaDQ@mail.gmail.com> (sfid-20130614_233852_753982_48F07C0A)
Subject: Re: [PATCH v2] {nl,mac,cfg}80211: Allow user to configure basic rates
 for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Jun 11, 2013 at 5:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-06-03 at 10:33 -0700, Ashok Nagarajan wrote:
>> Currently mesh uses mandatory rates as the default basic rates. Allow basic
>> rates to be configured during mesh join. Basic rates are applied only if
>> channel is also provided with mesh join command.
>
> Applied, I fixed some whitespace and made it remove rates specification
> w/o channel specification. Please check.
>

I checked it. Thank you.

> johannes
>



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
