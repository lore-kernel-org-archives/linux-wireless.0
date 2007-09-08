Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:41815 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbXIHRIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 13:08:01 -0400
Received: by ug-out-1314.google.com with SMTP id z38so359145ugc
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 10:08:00 -0700 (PDT)
To: "Rob Hussey" <robjhussey@gmail.com>
Subject: Re: Kernel panic with rt2500pci built-in
Date: Sat, 8 Sep 2007 19:18:45 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com> <200709081816.10143.IvDoorn@gmail.com> <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
In-Reply-To: <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709081918.45514.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 September 2007, Rob Hussey wrote:
> On 9/8/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> >
> > And there was no rt2x00lib, rt2x00pci or rt2500pci error message
> > in the log that could indicate why the device is not present?
> 
> Not in the log, but on the screen. I should've noticed not everything
> was in there. Here's what shows up:
> 
> wmaster0: Failed to select rate control algorithm

Did you load rc80211_simple or rc80211_lowest after modprobing mac80211?

Ivo
