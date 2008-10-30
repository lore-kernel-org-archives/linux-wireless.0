Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17051 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYJ3VUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 17:20:04 -0400
Received: by nf-out-0910.google.com with SMTP id d3so395115nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 14:19:55 -0700 (PDT)
Message-ID: <490A24F0.7010305@gmail.com> (sfid-20081030_222010_889806_19FAD2C4)
Date: Thu, 30 Oct 2008 21:19:44 +0000
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Pavel Roskin <proski@gnu.org>,
	kilroyd <kilroyd@googlemail.com>
Subject: Re: [PATCH v2] don't use net/ieee80211.h
References: <1225243531.1369.18.camel@johannes.berg>	 (sfid-20081029_125021_786122_12E56128) <1225400994.3690.86.camel@johannes.berg>
In-Reply-To: <1225400994.3690.86.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Convert all the drivers using net/ieee80211.h to use linux/ieee80211.h.
> Contains a bugfix in libertas where the SSID parsing could overrun the
> buffer when the AP sends invalid information.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Acked-by: Dan Williams <dcbw@redhat.com> [airo, libertas]
> ---
>  drivers/net/wireless/orinoco.c             |   30 ++++++-----

Orinoco bits Acked-by: David Kilroy <kilroyd@googlemail.com>


Thanks,

Dave.
