Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45069 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1IPLKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 07:10:37 -0400
Received: by gxk6 with SMTP id 6so2199058gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 04:10:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316166964.4130.4.camel@jlt3.sipsolutions.net>
References: <1316100982-1815-1-git-send-email-wey-yi.w.guy@intel.com>
	<CAGXE3d8rVyF9VTtjDtatvX9e6dKLAGtYNEq5wEfvNGLtu_U9UQ@mail.gmail.com>
	<1316166964.4130.4.camel@jlt3.sipsolutions.net>
Date: Fri, 16 Sep 2011 13:10:36 +0200
Message-ID: <CAGXE3d8Ctx9-yD=2W=d_wJRSFHW7RHo=w1+ZKbN_wU97YnD-0A@mail.gmail.com> (sfid-20110916_131043_096395_A9FC6E9A)
Subject: Re: [PATCH 3.1] iwlagn: workaround bug crashing some APs
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 11:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> If we can crash APs by sending values != 64 or 0 it might even make sense
>> to not allow drivers to overwrite the max AMPDU size ...
>
> It isn't that sending that directly crashes the APs right away. It still
> needs some traffic, so there's a possibility that we send too long
> AMPDUs or something else like that and just can't find that bug ...

Understood, thanks Johannes.
