Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51405.mail.re2.yahoo.com ([206.190.38.184]:43741 "HELO
	web51405.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756049Ab0ANMjS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 07:39:18 -0500
Message-ID: <960946.85546.qm@web51405.mail.re2.yahoo.com>
Date: Thu, 14 Jan 2010 04:39:17 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: "iwconfig wlan0 rate auto" fails on latest wireless-testing with ath9k
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
if I set a fixed data rate with iwconfig I can't get out anymore.
Trying to switch back to automatic rate control gives an error message:

Script started on Thu Jan 14 13:18:14 2010
root@ath9k-0-007:~# iwconfigwlan0
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

wlan0     IEEE 802.11abgn  ESSID:"athtest5200"  
          Mode:Ad-Hoc  Frequency:5.2 GHz  Cell: 02:02:6F:23:12:0B   
          Tx-Power=20 dBm   
          Retry limit:7   RTSthr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
root@ath9k-0-007:~# iwconfigwlan0 rate 6M
root@ath9k-0-007:~# iwconfigwlan0
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

wlan0     IEEE 802.11abgn  ESSID:"athtest5200"  
          Mode:Ad-Hoc  Frequency:5.2 GHz  Cell: 02:02:6F:23:12:0B   
          Tx-Power=20 dBm   
          Retry limit:7   RTSthr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          
root@ath9k-0-007:~# iwconfigwlan0 rate auto
Error for wireless request "Set Bit Rate" (8B20) :
    SET failed on device wlan0 ; Invalid argument.
root@ath9k-0-007:~# 
Script done on Thu Jan 14 13:18:56 2010

Funny thing is, not even "rmmodath9k mac80211" is enough to get out of
the fixed data rate.

Any ideas? And, BTW. will there be a way to set the data rate with iw?

 -- 
Regards 
Joerg 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
