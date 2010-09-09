Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49545 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0IIFxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:53:06 -0400
Received: by qyk36 with SMTP id 36so5621968qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 22:53:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=-62L5C02bG_UrTjV0VUE5AZ35C_223vXiRXei@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
	<1283988329-44549-9-git-send-email-steve@cozybit.com>
	<AANLkTi=-62L5C02bG_UrTjV0VUE5AZ35C_223vXiRXei@mail.gmail.com>
Date: Wed, 8 Sep 2010 22:53:05 -0700
Message-ID: <AANLkTikD3Z9_38jH1iCayZbdqJL4dstPGGFBgerX7dWe@mail.gmail.com>
Subject: Re: [PATCH 8/9] libertas_tf: updated with beacon code
From: Steve deRosier <steve@cozybit.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 8, 2010 at 7:21 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Also, it appears that this patch does two things, update the beacon
> code and add some debugging. You may want to separate this into two
> patches.

Well, the debugging was added _for_ the beacon code and to debug the
beacon code either here in the driver or the interaction with new
beacon code in the firmware.

Thanks,
- Steve
