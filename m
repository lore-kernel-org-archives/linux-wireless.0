Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58230 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJIPgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 11:36:03 -0400
Received: by mail-wi0-f176.google.com with SMTP id hi2so13538030wib.15
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 08:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412865379.1828.52.camel@jlt4.sipsolutions.net>
References: <1410505183-7325-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1412865379.1828.52.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Thu, 9 Oct 2014 17:35:39 +0200
Message-ID: <CAGnRvuoERgLuhJf4+2+PwOctVg-dzD4kPLiAsOYOuCzf+2FF4g@mail.gmail.com> (sfid-20141009_173609_275502_EAB0FABE)
Subject: Re: [PATCH v2] Add mpp get/dump commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2014 at 4:36 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-09-12 at 08:59 +0200, Henning Rogge wrote:
>> Add the "mpp get" and "mpp dump" command to query to mac80211s mesh
>> proxy path table through nl80211.
>
> Applied.
>
>>  nl80211.h | 11 +++++++++
>
> Please don't send me nl80211.h updates though.

Had to change it to make the source compile... so next time change it,
but not add it to the commit?

Henning Rogge
