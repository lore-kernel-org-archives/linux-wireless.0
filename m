Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38105 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3HUIjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:39:51 -0400
Received: by mail-ve0-f171.google.com with SMTP id pa12so92325veb.30
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 01:39:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377032500.13829.41.camel@jlt4.sipsolutions.net>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	<1377020479-16935-12-git-send-email-k.eugene.e@gmail.com>
	<1377032500.13829.41.camel@jlt4.sipsolutions.net>
Date: Wed, 21 Aug 2013 10:39:50 +0200
Message-ID: <CAFSJ42YWHkMr-qvTxJbCF3=+fJYYpEgp1uxPw=aY78cjk2ieew@mail.gmail.com> (sfid-20130821_103955_291589_12377F9E)
Subject: Re: [PATCH 11/16] wcn36xx: Add txrx.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +     /* Data frames served first*/
>> +     if (is_low) {
>> +             /*
>> +              * Sometimes in AP mode mac80211 is trying to send data
>> +              * frame to nobody. Why?
>> +              */
>> +             if (!sta_priv)
>> +                     wcn36xx_warn("Sending data packet to nobody");
>
> Umm, really? Have you heard of something called multicast? ;-)
>

Do not know who wrote this code but this comment definitely must be removed!

-- 
Best regards,
Eugene
