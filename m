Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1KUSN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:13:56 -0500
Date: Mon, 21 Nov 2011 12:13:50 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
Message-ID: <20111121181350.GC6736@thinkpad-t410> (sfid-20111121_191359_768499_192B283A)
References: <20111118225422.GD19138@thinkpad-t410>
 <4EC88F58.1080203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EC88F58.1080203@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 19, 2011 at 11:25:44PM -0600, Larry Finger wrote:
> On 11/18/2011 04:54 PM, Seth Forshee wrote:
> >I'm seeing a lot of problems associating with APs when using a Toshiba
> >NB505 with RTL8188CE wireless. The situation seems to have improved
> >quite a bit when I moved from 3.0 to 3.2-rc2, but I still see a good
> >number of failed associations. This card doesn't seem to like my Linksys
> >E2000 router in particular; I rarely see a successful association with
> >this router.
> >
> >I'm attaching logs from the kernel and wpa_supplicant from some failed
> >associations with the E2000 along with the wpa_supplicant configuration
> >I used. I loaded rtl8192ce with debug=3, but if more verbosity or any
> >other information is needed, please let me know.
> 
> Would it be possible for you to have a separate computer log the
> transaction between the AP with ESSID 'Kailia' and the RTL8188CE
> using wireshark or Kismet? Chaoming may see something in the logs
> that I do not, but the request for authentication is timing out.
> With wireshark, we can see what is actually on the air.

I've uploaded the capture along with the logs to
http://people.canonical.com/~sforshee/rtl8188ce/.

Thanks,
Seth
