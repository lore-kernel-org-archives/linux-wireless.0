Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1HBDxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 23:53:34 -0400
Received: by fxh19 with SMTP id 19so5196323fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 20:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1312228017-12061-1-git-send-email-wey-yi.w.guy@intel.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 1 Aug 2011 20:53:12 -0700
Message-ID: <CALSq=BYkKhJN=GU0RUJ2viibsy5yG78x-D-td0zP+rqWCy=AiQ@mail.gmail.com> (sfid-20110802_055342_992036_8E9AC6BE)
Subject: Re: [PATCH wireless-3.1] iwlagn: sysfs couldn't find the priv pointer
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 1, 2011 at 12:46 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> This bug has been introduced by:
> d593411084a56124aa9d80aafa15db8463b2d8f7
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Mon Jul 11 10:48:51 2011 +0300
>
>    iwlagn: simplify the bus architecture
>

Believe this fix needs to go to 3.0-stable too.

Dan
