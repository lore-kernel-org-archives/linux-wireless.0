Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33179 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbEYH7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 03:59:10 -0400
Received: by iebgx4 with SMTP id gx4so67977935ieb.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 00:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <255092351.26861432539449201.JavaMail.weblogic@epmlwas02a>
References: <255092351.26861432539449201.JavaMail.weblogic@epmlwas02a>
Date: Mon, 25 May 2015 09:59:09 +0200
Message-ID: <CACna6ryChb36jRXDFMXj-O9Xkr3VHrE=nzSwFjs427xmgArpgw@mail.gmail.com> (sfid-20150525_095915_575131_500D38AE)
Subject: Re: [PATCH] Reordering for better readability and consistency [EDT]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: rahul.jain@samsung.com
Cc: "johannes.berg@intel.com" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 May 2015 at 09:37, Rahul Jain <rahul.jain@samsung.com> wrote:
> hello Wireless Community,

Hi :)


> Please find patch for review.
>
> From 328fb9d1b772788fc51e7f9bb21e57a1d91b0188 Mon Sep 17 00:00:00 2001
> From: Rahul Jain <rahul.jain@samsung.com>
> Date: Mon, 25 May 2015 12:02:12 +0530
> Subject: [PATCH] Reordering for better readability and consistency

You should prefix your patch subject. It's usually the easiest to
check git history to see what kind of prefix is usually used for the
code you edit, like:
git log net/wireless/util.c


> @@ -1340,10 +1340,7 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
>         case 128 ... 130:
>                 *band = IEEE80211_BAND_5GHZ;
>                 return true;
> -       case 81:
> -       case 82:
> -       case 83:
> -       case 84:
> +       case 81 ... 84:
>                 *band = IEEE80211_BAND_2GHZ;
>                 return true;
>         case 180:

I guess there could be some better word than "Reordering" for this
change. I don't think you really reordered anything ;)

-- 
Rafał
