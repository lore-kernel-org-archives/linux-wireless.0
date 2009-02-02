Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:13128 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZBBVdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 16:33:14 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1880267wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 13:33:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7c8826910902021255g2563400an24f97014abf854f8@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <45e8e6c40901240956g68a5364tdbacc1e49410c9cc@mail.gmail.com>
	 <e27b78a40901260625w53acd646xeb5a9ca85555c74d@mail.gmail.com>
	 <e27b78a40901260956w4e69d33s7db60defc026c8d7@mail.gmail.com>
	 <45e8e6c40901280954l42bbe788y8723141d673bb7b3@mail.gmail.com>
	 <e27b78a40901300446y294504d5kd7acaa6c5a26edd@mail.gmail.com>
	 <e27b78a40901300601p35d68125kfc3a10a7d7db0900@mail.gmail.com>
	 <7c8826910901301109s6d80a75ale251ec837eabccf0@mail.gmail.com>
	 <e27b78a40902021013v272ec315nece744d3cf1dc75c@mail.gmail.com>
	 <7c8826910902021255g2563400an24f97014abf854f8@mail.gmail.com>
Date: Mon, 2 Feb 2009 16:33:14 -0500
Message-ID: <b6c5339f0902021333x2880b7dfj279822622a3d5cc3@mail.gmail.com> (sfid-20090202_223320_724770_89653282)
Subject: Re: Crashing on ping?
From: Bob Copeland <bcopeland@gmail.com>
To: Mike Cui <cuicui@gmail.com>
Cc: Keir <keirlawson@gmail.com>, Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2009 at 3:55 PM, Mike Cui <cuicui@gmail.com> wrote:
> No. crash happens when I use it in regular access point mode.
>

Do you have a stack trace?  And does this patch help?

http://bugzilla.kernel.org/attachment.cgi?id=19985
-- 
Bob Copeland %% www.bobcopeland.com
