Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57998 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3EMRN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 13:13:27 -0400
Received: by mail-wi0-f177.google.com with SMTP id hr14so3208386wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 10:13:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368438160.8300.11.camel@jlt4.sipsolutions.net>
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
 <1368233453-10581-2-git-send-email-ashok@cozybit.com> <1368438160.8300.11.camel@jlt4.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Mon, 13 May 2013 10:13:05 -0700
Message-ID: <CACcxo+odk2L-pymHqof+geeEmKcC4xikebra9jcNZoHOF0by4A@mail.gmail.com> (sfid-20130513_191329_829802_31E8D935)
Subject: Re: [PATCH 2/3] cfg80211: Allow ieee80211g mandatory rate sets in
 2.4GHz band
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 13, 2013 at 2:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-05-10 at 17:50 -0700, Ashok Nagarajan wrote:
>> This patch assumes 11g support
>> implies a 11g operation and returns the appropriate mandatory rates.
>
> Which is a problem, because it means that by default we'll create IBSS
> networks that are not compatible with 11b devices.

Okay make sense. I would drop just this patch and send rest.

Thanks,
Ashok
>
> johannes
>



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
