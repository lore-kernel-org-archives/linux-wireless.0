Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:17769 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYEPQQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 12:16:15 -0400
Received: by el-out-1112.google.com with SMTP id s27so273985ele.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 09:16:14 -0700 (PDT)
Message-ID: <69e28c910805160916o68ba2512k3aaab29d592c54ff@mail.gmail.com> (sfid-20080516_181646_957987_A6F31548)
Date: Fri, 16 May 2008 18:16:13 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Martin Dubuc" <martind1111@gmail.com>
Subject: Re: [ipw3945-devel] Monitor mode on boot
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <7a0107ba0805160906r4bfcd09ch6e550b929e3bd21d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7a0107ba0805151404o778a09ddj522fffa3edbeec6@mail.gmail.com>
	 <69e28c910805160316q7c1b869an7fd554979ea260b8@mail.gmail.com>
	 <7a0107ba0805160627l55f53b04r69a32e1bba36ecb6@mail.gmail.com>
	 <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com>
	 <20080516150824.GB6510@tuxdriver.com>
	 <7a0107ba0805160906r4bfcd09ch6e550b929e3bd21d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 6:06 PM, Martin Dubuc <martind1111@gmail.com> wrote:
> John,
>
> I do not believe the script later in the thread will suffice. As far as I
> can understand, the script will create one interface in monitor mode for
> each wmasterX (which is good), but the system will also bring up one managed
> mode interfaces in parallel for each wmasterX. In my use case, I only want
> an interface of device type X to come up in monitor mode and I don't want a
> managed mode interface created in parallel.
>
> I need to create multiple monitor interfaces on the same box because my
> application dedicates interfaces for the capture of traffic on specific
> channels.
>
> Martin

Why is the existence of managed interfaces a problem? Unlike madwifi,
mac80211 really supports multiple interfaces on one device.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
