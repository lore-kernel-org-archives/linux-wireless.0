Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44850 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbYIRSk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:40:56 -0400
Received: by gxk9 with SMTP id 9so31666561gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:40:55 -0700 (PDT)
Message-ID: <43e72e890809181140w4a8383a8m894ad3eb063a9325@mail.gmail.com> (sfid-20080918_204100_449880_B8E116E6)
Date: Thu, 18 Sep 2008 11:40:55 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Gordon, Charles" <Charles.Gordon@digi.com>
Subject: Re: What is the state of 802.11h support?
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B718874D96D@mtk-sms-exch01.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <AckZmy0eHmfRhhimQY2qv8c0gfzxmQ==>
	 <8DCC153EAFE67A4B990A840E829F704B718874D96D@mtk-sms-exch01.digi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 7:31 AM, Gordon, Charles
<Charles.Gordon@digi.com> wrote:
> Can someone tell me how much of 802.11h is supported by Linux?  What is the plan for completing it enough so that it implements a client which complies with the specification?
>
> What needs to be implemented in the wireless NIC driver to support 802.11h?  My company is working on a wireless NIC driver for Linux.

We have no 11h support in mac80211. Not too sure what part would be
required in drivers. First step would be to disable using all 11h
channels for now as we don't have support for it. In wireless-testing
you can check for this if the channel flag has IEEE80211_CHAN_RADAR.
Some initial 11h patches were posted a while back for RFC, you can
search for those as well. We will soon look into this as well if its
not yet completed.

  Luis
