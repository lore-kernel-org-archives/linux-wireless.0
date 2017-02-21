Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35843 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdBUBoN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 20:44:13 -0500
Received: by mail-it0-f67.google.com with SMTP id w185so7556836ita.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 17:44:12 -0800 (PST)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com. [209.85.214.41])
        by smtp.gmail.com with ESMTPSA id r203sm5643802itc.5.2017.02.20.17.44.11
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Feb 2017 17:44:11 -0800 (PST)
Received: by mail-it0-f41.google.com with SMTP id d9so29176234itc.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 17:44:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vasb96ep.fsf@purkki.adurom.net>
References: <20170210090231.14696-1-andrew.zaborowski@intel.com>
 <1487147264.4026.13.camel@sipsolutions.net> <87vasb96ep.fsf@purkki.adurom.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Tue, 21 Feb 2017 02:44:10 +0100
Message-ID: <CAOq732LwAs6bG5dPMuBWA7MnSMLSRyySEq-2y2niDU0ZsFRNfA@mail.gmail.com> (sfid-20170221_024416_711564_1DC1D659)
Subject: Re: [PATCH v6 1/3] cfg80211: Accept multiple RSSI thresholds for CQM
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 15 February 2017 at 09:58, Kalle Valo <kvalo@codeaurora.org> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>> On Fri, 2017-02-10 at 10:02 +0100, Andrew Zaborowski wrote:
>>> Change the SET CQM command's RSSI threshold attribute to accept any
>>> number of thresholds as a sorted array.  The API should be backwards
>>> compatible so that if one s32 threshold value is passed, the old
>>> mechanism is enabled.  The netlink event generated is the same in
>>> both cases.
>>
>> I've applied this now, thanks for your patience :)
>>
>> I got a bit confused - and then fixed it up - patchwork has giving your
>> name as "Andrzej Zaborowski" which apparently you didn't really want
>> (any more). I've fixed it for these patches to be as the patches you
>> sent, but no guarantees I've done this before or will remember to do
>> that in the future - if you can somehow change your name in patchwork
>> (patchwork.kernel.org) that would be good.

Thanks, changed it for consistency now.

>
> IIRC if you haven't registered to patchwork.kernel.org it's possible to
> change the name easily. But after registration the user needs to contact
> helpdesk to change the name.

Indeed I was able to set name on registration today but can see no way
to modify it.  The project's mailing list has a thread about a patch
that's about to be backported to the patchwork.kernel.org version
though, https://github.com/getpatchwork/patchwork/commit/d365402fb98dfb2c4aea4b58346096f85bdfa0c3

Best regards
