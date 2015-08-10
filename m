Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:54836 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbHJMCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 08:02:17 -0400
Date: Mon, 10 Aug 2015 22:01:54 +1000
From: James Cameron <quozl@laptop.org>
To: Kai Heng Feng <kai.heng.feng@canonical.com>
Cc: AceLan Kao <acelan.kao@canonical.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8723be: disable FW control power save
Message-ID: <20150810120154.GA22283@us.netrek.org> (sfid-20150810_140221_278844_99424924)
References: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
 <55C4DDF5.6010901@lwfinger.net>
 <CAFv23Qk285G47pPVrfUn5izfZyrc-vCSPqJamnoxQMm6Ae9zpQ@mail.gmail.com>
 <20150810041957.GA7681@us.netrek.org>
 <CAAd53p5Lwm-2qDh=hc8Kp8XYUafxksyQn9ouOjHW_PymPQ-i9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAd53p5Lwm-2qDh=hc8Kp8XYUafxksyQn9ouOjHW_PymPQ-i9w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2015 at 06:47:05PM +0800, Kai Heng Feng wrote:
> Do you use Ubuntu Trusty (14.04)?

Yes, that's what I'm using.

> The rtl8723be firmware is not up-to-date in Trusty's linux-firmware.
> You can grab the newer one from the upstream linux-firmware.

Thanks, but both seem to work fine (apart from the issue in this
thread), and I don't have a list of what has changed.

-- 
James Cameron
http://quozl.linux.org.au/
