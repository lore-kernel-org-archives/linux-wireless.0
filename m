Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:43281 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbeHMRIc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 13:08:32 -0400
MIME-Version: 1.0
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com> <5B708025.4090906@broadcom.com> <CAJ0CqmVZNAnHwnU4YqRRv7R8DyHi2MiFJr1bvQDPVszUU5Ez3g@mail.gmail.com>
In-Reply-To: <CAJ0CqmVZNAnHwnU4YqRRv7R8DyHi2MiFJr1bvQDPVszUU5Ez3g@mail.gmail.com>
From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Mon, 13 Aug 2018 16:25:51 +0200
Message-ID: <CAKfDRXia3zwW9Q=7RZGqK_DWCsyQzG4KEZHsyHzGcNb70Ge1kA@mail.gmail.com> (sfid-20180813_162608_778705_CC3E2202)
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
To: lorenzo.bianconi@redhat.com
Cc: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lorenzo,

On Mon, Aug 13, 2018 at 12:55 PM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
> According to my understanding (please correct me if I am wrong)
> BSS_CHANGED_CQM is only needed if CQM_RSSI is handled
> by the driver/fw, while if it is not set mac80211 will take care of that
> in ieee80211_handle_beacon_sig routine.
> I am AFK at the moment, I will test that patch when I am back from vacations.

That matches my understanding as well (base on for example the message
for commit ae44b502669d0cd1f167cdb48994292aa20fd3dd).

Great that you are willing to test the patch with one of the mt76
USB-dongles. Unless anyone objects, I will postpone sending a v2 until
you report back with your findings :)

BR,
Kristian
