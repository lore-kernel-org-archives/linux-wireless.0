Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53397 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1KTFZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 00:25:48 -0500
Received: by iage36 with SMTP id e36so5657112iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 21:25:47 -0800 (PST)
Message-ID: <4EC88F58.1080203@lwfinger.net> (sfid-20111120_062605_440313_AECBBAFF)
Date: Sat, 19 Nov 2011 23:25:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <20111118225422.GD19138@thinkpad-t410>
In-Reply-To: <20111118225422.GD19138@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 04:54 PM, Seth Forshee wrote:
> I'm seeing a lot of problems associating with APs when using a Toshiba
> NB505 with RTL8188CE wireless. The situation seems to have improved
> quite a bit when I moved from 3.0 to 3.2-rc2, but I still see a good
> number of failed associations. This card doesn't seem to like my Linksys
> E2000 router in particular; I rarely see a successful association with
> this router.
>
> I'm attaching logs from the kernel and wpa_supplicant from some failed
> associations with the E2000 along with the wpa_supplicant configuration
> I used. I loaded rtl8192ce with debug=3, but if more verbosity or any
> other information is needed, please let me know.

Would it be possible for you to have a separate computer log the transaction 
between the AP with ESSID 'Kailia' and the RTL8188CE using wireshark or Kismet? 
Chaoming may see something in the logs that I do not, but the request for 
authentication is timing out. With wireshark, we can see what is actually on the 
air.

Larry

