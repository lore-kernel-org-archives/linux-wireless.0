Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:11612 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763255AbXGSWHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 18:07:12 -0400
Received: by wa-out-1112.google.com with SMTP id v27so792781wah
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2007 15:07:12 -0700 (PDT)
Message-ID: <d120d5000707191507y76dd6e4dw4ce14ffdd055ceaa@mail.gmail.com>
Date: Thu, 19 Jul 2007 18:07:09 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Merging P54 upstream?
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <20070719212602.GA12449@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <d120d5000707191409y7602a2bdk3b9e67f5bce009d@mail.gmail.com>
	 <20070719212602.GA12449@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/19/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Jul 19, 2007 at 05:09:21PM -0400, Dmitry Torokhov wrote:
>
> > I wonder if there are any plans to merge p54 driver into mainline
> > anytime soon? For some reason p54 works much better for me on my
> > FullMAC card than prism54 (with which card started locking up after ~5
> > min heavyish use, such as FTP since about a year or a year and a half
> > ago).
>
> Michael Wu is the author of that driver.  I know he is working an
> internship this summer, so he may be a bit busy.  Still, I sincerely
> hope he finds the time to whip this driver into mergeable shape and
> submits it for upstream soon.
>

OK, if he needs a guinea pig I should be available, especially for
patches against tip of Linus's tree.

-- 
Dmitry
