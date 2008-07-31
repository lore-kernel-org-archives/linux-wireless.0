Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:33718 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbYGaT3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 15:29:50 -0400
Received: by wf-out-1314.google.com with SMTP id 27so930194wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 12:29:49 -0700 (PDT)
Message-ID: <69e28c910807311229h781e3b61h9fff9316ea6d80be@mail.gmail.com> (sfid-20080731_212954_840333_09096EE8)
Date: Thu, 31 Jul 2008 21:29:49 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: ath9k and N wireless on B frequencies
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200807311900.m6VJ0qQV023348@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200807311900.m6VJ0qQV023348@bromo.msbb.uc.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 9:00 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>   Does anyone know if the new ath9k wireless driver supports the N wireless
> connections on the B wireless frequencies? The Apple Airport Extreme supports
> the N protocols on both the G and B frequencies. Since Linksys is providing
> little support for my WRT150N (which shows uneven performance under N wireless
> to a MacBook Pro under Leopard compared to rock solid G performance), I
> am considering upgrading to an Airport Extreme base station and would like to
> make use of the N protocols under B wireless frequencies option in Linux.
> Thanks in advance for any information.
>            Jack

802.11b and 802.11g both use 14 channels in the 2.4GHz band, of which
11 is available in the US (13 in the EU) - it's 802.11a which uses
5GHz channels. Did you mean "N protocols under A frequencies"?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
