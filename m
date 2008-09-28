Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:35387 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYI1Q20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:28:26 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1845295rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 09:28:25 -0700 (PDT)
Message-ID: <69e28c910809280928o200d5ef8ree1188d668bbeb4@mail.gmail.com> (sfid-20080928_182828_840191_DB332498)
Date: Sun, 28 Sep 2008 18:28:25 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables aireplay-ng and others to work
Cc: Paul <paul14075@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1222571710.2510.587.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
	 <1222571710.2510.587.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 28, 2008 at 5:15 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> Isn't the rtap_iface does the same thing? Did you try it?
>
> Thanks,
> -yi

AFAIK rtap_iface only gives a receive-only Radiotap monitor interface
- it doesn't support injection.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
