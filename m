Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from segment-119-226.sify.net ([119.226.185.252]:58181 "EHLO
	gesmail.globaledgesoft.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753520Ab2I1LMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 07:12:14 -0400
Message-ID: <54902.192.168.200.1.1348830853.squirrel@gesmail.globaledgesoft.com> (sfid-20120928_131217_436732_A2B8B252)
In-Reply-To: <87k3vg3e8r.fsf@purkki.adurom.net>
References: <CACuskh++j1QPgvBNhpGmhUOjwozk2vybHq=3_-iSoWaAVxkEvw@mail.gmail.com>
    <87k3vg3e8r.fsf@purkki.adurom.net>
Date: Fri, 28 Sep 2012 16:44:13 +0530 (IST)
Subject: Re: Which tree to pull for submitting patches to net/mac80211
From: kirankumar.b@globaledgesoft.com
To: "Kalle Valo" <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much for your clarity : )

> kiranaab ki <kiranaab@gmail.com> writes:
>
>> I also see in MAINTAINERS list that Johannes Berg maintains two trees
>>    mac80211.git,
>>    mac80211-next.git
>>
>> If I want to send the patches for net/mac80211 and net/cfg8011
>> do I need to pull wireless-testing.git and send the patches so that
>> John W Linwille reviews them
>>
>>      or
>>
>> do I need to pull mac80211-next.git and send the patches so that
>> Johannes Berg will review the patches and later John W Linville
>> pulls the changes from Johannes's tree along the development process ?
>
> For new people in the Linux development I would recommend to use
> wireless-testing and submit patches to the linux-wireless mailing, just
> to keep things simple. Johannes when picks up the patch whenever he has
> time.
>
> In rare occasions your patch might conflict with something which is in
> mac80211-next and Johannes might ask you to rebase your patch. But this
> usually happens when making more extensive changes to mac80211, for
> smaller patches this is really rare.
>
> --
> Kalle Valo
>

