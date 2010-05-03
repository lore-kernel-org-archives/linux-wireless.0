Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:43080 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab0ECWtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 18:49:42 -0400
Received: by pzk42 with SMTP id 42so430252pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 15:49:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87633al6di.fsf@purkki.valot.fi>
References: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
	<87633al6di.fsf@purkki.valot.fi>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 May 2010 15:44:39 -0700
Message-ID: <o2z43e72e891005031544ufd3f84a5g4e0a3a0dceac8002@mail.gmail.com>
Subject: Re: [RFC PATCHv4 0/2] mac80211: cfg80211: dynamic ps timeout based on
	pm-qos
To: Kalle Valo <kvalo@adurom.com>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 29, 2010 at 6:45 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
>
>> These patches propose a way to adjust the dynamic ps timeout in the
>> mac80211 based on the pm-qos network latency value. This allows user
>> space to influence the level of power saving performed by the
>> mac80211.
>>
>> v4 of these patches change the way pm qos network latency ranges
>> converted to dynamic ps timeout values a little bit saner. Unlike
>> the previous set of patches, now the latancy values make sense in a
>> wider scope than this ps timeout thing only. I hope this makes them
>> somewhat more future-proof.
>
> This looks very good now. Bonus points for adding the comment about
> the two second value!
>
> Thank you for implementing this.

Even more bonus points (if this was a video game you'd get an extra
life) if you add the new changes on the documentation here:

http://wireless.kernel.org/en/developers/Documentation/pm-qos

  Luis
