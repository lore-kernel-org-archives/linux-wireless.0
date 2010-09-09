Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33082 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0IIGq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 02:46:28 -0400
Received: by bwz11 with SMTP id 11so852098bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 23:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikD3Z9_38jH1iCayZbdqJL4dstPGGFBgerX7dWe@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
 <1283988329-44549-9-git-send-email-steve@cozybit.com> <AANLkTi=-62L5C02bG_UrTjV0VUE5AZ35C_223vXiRXei@mail.gmail.com>
 <AANLkTikD3Z9_38jH1iCayZbdqJL4dstPGGFBgerX7dWe@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 16:46:07 +1000
Message-ID: <AANLkTi=1WjgohimscMqGjJQB3YF25s52DnvBjHzmdEwO@mail.gmail.com>
Subject: Re: [PATCH 8/9] libertas_tf: updated with beacon code
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 15:53, Steve deRosier <steve@cozybit.com> wrote:
> On Wed, Sep 8, 2010 at 7:21 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Also, it appears that this patch does two things, update the beacon
>> code and add some debugging. You may want to separate this into two
>> patches.
>
> Well, the debugging was added _for_ the beacon code and to debug the
> beacon code either here in the driver or the interaction with new
> beacon code in the firmware.

You should probably mention that in the commit message then.

libertas_tf: Update beacon code

Update beacon code and add beacon debugging info.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
