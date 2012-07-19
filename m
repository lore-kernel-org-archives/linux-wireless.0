Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:56925 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab2GSLzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 07:55:12 -0400
From: Ivanich <ivanich@ivanich.org.ua>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: hostapd locks during restart
Date: Thu, 19 Jul 2012 14:55:10 +0300
Message-ID: <3973848.eJNoskK5Tf@ivanich> (sfid-20120719_135515_900697_E265041C)
In-Reply-To: <CAD2nsn2fMJogNmfzee0NyrvBxnfi=5KhUny+8ayu-XM5ZGPYog@mail.gmail.com>
References: <1375660.IC4Ixsn6lK@ivanich> <CAD2nsn2fMJogNmfzee0NyrvBxnfi=5KhUny+8ayu-XM5ZGPYog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Четверг, 19-июл-2012 15:19:25 Mohammed Shafi wrote:
> On Thu, Jul 19, 2012 at 2:24 PM, Ivanich <ivanich@ivanich.org.ua> wrote:
> > In the latest wireless-testing.git hostapd deadlock during restart, using
> > rtl8192ce in AP mode.
> 
> please check if this is related to
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/95061
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
Yes this patch helps, hostapd now restarting fine.
