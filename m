Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34948 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2CWAzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 20:55:01 -0400
Received: by ghrr11 with SMTP id r11so2362250ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2012 17:55:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986ZP6bPBNXY2OtjyM_Sn8F1dUsZOAPTE_bSkAE6==Tx0w@mail.gmail.com>
References: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com>
 <201203221958.10427.lindner_marek@yahoo.de> <CAPjQAd-j0mP9faqSkwuDWErX1v+dbzYqO+rL6sKN-2ZMYr_FGA@mail.gmail.com>
 <201203222035.50568.lindner_marek@yahoo.de> <CAEFj986ZP6bPBNXY2OtjyM_Sn8F1dUsZOAPTE_bSkAE6==Tx0w@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 22 Mar 2012 17:54:40 -0700
Message-ID: <CAPjQAd-CM-oe_-=w6BcCjUuPmbimwBXMjPqR=2p4G-i=x3Frbg@mail.gmail.com> (sfid-20120323_015507_862447_E75D8BC3)
Subject: Re: [PATCH v2] mac80211: fix the RANN propagation issues
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	thomas@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 22, 2012 at 5:47 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> "In the section 11C.9.8.3 HWMP sequence numbering, Comparing HWMP
> sequence numbers is done using a circular modulo 232 comparison."

That would be section 13.10.8.3 in the ratified version of the
standard.  And it's modulo 2³² (2^32), not 232 :)

Cheers,

Javier
